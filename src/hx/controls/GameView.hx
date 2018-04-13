package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Timer;
import js.Lib;
import matter.Body;
import matter.Vector;
import particles.ParticleManager;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import util.MathUtil;
import util.Pool;
import controls.Collectable.CType;
import controls.Compound.CompoundType;
/**
 * ...
 * @author Henri Sarasvirta
 */
@:expose("GV")
class GameView extends Container
{
	public static var CONF:REACTION;
	public var ui:UI;
	public var charpos:Point = new Point();
	
	private var blocks:Blocks;
	private var character:Character;
	private var time:Float = 0;
	
	private var dropSpeed:Float = 0;
	
	private var maxvelocity:Float = 3.0;
	
	private var test:Collectable;
	
	private var oxygen:Pool<Collectable>;
	private var lithium:Pool<Collectable>;
	private var magnesium:Pool<Collectable>;
	private var aluminium:Pool<Collectable>;
	private var brohm:Pool<Collectable>;
	private var allCollectables:Array<Pool<Collectable>>;
	private var active:Array<Collectable> = [];
	
	private var previousSpawn:Float = 0;
	private var size:Rectangle;
	private var collectables:Container;
	
	private var running:Bool = false;
	
	public var current:Array<CType>;
	public var extra:Array<CType>;
	private var baseconf:Array<CType>;
	
	private var jar:Jar;
	private var requiredPairs:Int;
	private var ending:Bool = false;
	
	public function new() 
	{
		super();
		
		this.oxygen = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.oxygen); } );
		this.lithium = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.lithium); } );
		this.magnesium = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.magnesium); } );
		this.aluminium = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.aluminium); } );
		this.brohm = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.brohm); } );
		
		this.allCollectables = [
			this.oxygen,
			this.lithium, 
			this.magnesium,
			this.aluminium,
			this.brohm
		];
		this.initializeControls();
	}
	
	public function start():Void
	{
		Body.setPosition(character.body, cast { x:0, y:0 } );
		this.blocks.alpha = 1;
		this.collectables.alpha = 1;
		Main.instance.bg.rememberPosition(charpos);
		Tween.get(this.character).to( { alpha:1 }, 1000);
		Tween.get(this.jar).to( { alpha:0 }, 1000);
		this.ending = false;
		this.collectables.removeChildren();
		this.blocks.clear();
		this.charpos.x = this.charpos.y = 0;
		this.active = [];
		this.extra = [];
		this.current = [];
		GameView.CONF = [
			{   //Li2O
				instruction:"litiumoksidin_reaktio_intro.png",
				final:"litiumoksidin_reaktio.png",
				conf:[CType.lithium, CType.lithium, CType.oxygen],
				compound:CompoundType.lithium_oxide
			}, 
			{   //LiBr
				instruction:"litiumbromidin_reaktio_intro.png",
				final:"litiumbromidin_reaktio.png",
				conf:[CType.lithium, CType.brohm],
				compound:CompoundType.lithium_bromide
			}, 
			{   //MgBr2
				instruction:"magnesiumbromidin_reaktio_intro.png",
				final:"magnesiumbromidin_reaktio.png",
				conf:[CType.magnesium, CType.brohm, CType.brohm],
				compound:CompoundType.mag_bromide
			}, 
			{   //MgO
				instruction:"magnesiumoksidin_reaktio_intro.png",
				final:"magnesiumoksidin_reaktio.png",
				conf:[CType.magnesium, CType.oxygen],
				compound:CompoundType.mag_oxide
			},
			{   //AlBr3
				instruction:"alumiinibromidin_reaktio_intro.png",
				final:"alumiinibromidin_reaktio.png",
				conf:[CType.aluminium, CType.brohm, CType.brohm, CType.brohm],
				compound:CompoundType.alu_bromide
			},
			{   //Al2O3
				instruction:"alumiinioksidin_reaktio_intro.png",
				final:"alumiinioksidin_reaktio.png",
				conf:[CType.aluminium, CType.aluminium, CType.oxygen, CType.oxygen, CType.oxygen],
				compound:CompoundType.alu_oxide
			} 
		][Math.floor(Math.random() * 6)];
		var conf:Array<CType> = CONF.conf;
		this.baseconf = conf;
		Body.setStatic(this.character.body, false);
		var amount:Int = Math.round(20 / conf.length);
		this.requiredPairs = 1;
		this.ui.updatePairAmount(this.requiredPairs);
		var types:Array<CType> = [];
		for (t in conf) if (types.indexOf(t) == -1) types.push(t);
		
		this.ui.target1.setType(types[0]);
		this.ui.target2.setType(types[1]);
		
		this.running = true;
		
		this.updatePairs();
	}
	
	public function applyCharMove(angle:Float):Void
	{
		if (angle < 0)
			angle = Math.max( -8, angle);
		else if (angle > 0)
			angle = Math.min( 8, angle);
		Body.applyForce(this.character.body, cast { x:0, y:0 }, cast { x:-angle / 15, y:0 } );
		this.charpos.x += angle;
	}
	
	private function initializeControls():Void
	{
		this.collectables = new Container();
		this.character = new Character();
		Body.setStatic(this.character.body, true);
		this.blocks = new Blocks();
		this.addChild(this.blocks);
		this.addChild(this.collectables);
		this.addChild(this.character);
		
		this.jar = new Jar();
		this.addChild(this.jar);
		this.jar.visible = false;
		Main.instance.tickListeners.push(onTick);

		this.character.alpha = 0;

	}
	
	private function onTick(delta:Float):Void
	{
		time+= delta;
		
		if (!running) return;
		this.charpos.x = character.body.position.x;
		this.charpos.y = character.body.position.y;
		
		Body.setVelocity(this.character.body,cast {
			x:Math.min(maxvelocity, Math.max( -maxvelocity, this.character.body.velocity.x)),
			y:Math.max( -maxvelocity, Math.min(maxvelocity, this.character.body.velocity.y))
		});
		
		Main.instance.bg.update(-charpos.x, -charpos.y);
		this.blocks.y = -charpos.y;
		this.blocks.x = -charpos.x;
		this.collectables.x = -charpos.x;
		this.collectables.y = -charpos.y;
		
		if (!ending)
		{
			this.blocks.update(charpos);
			this.spawnCollectable();
			this.collect();
		}
		
	}
	
	private function collect():Void
	{
		var remove:Array<Collectable> = [];
		for (c in active)
		{
			var p:Point = new Point(size.width/2, size.height/2);
			var cp:Point = collectables.toLocal(p);
			
			var dx:Float = cp.x - c.x;
			var dy:Float = cp.y - c.y;
			var d:Float = Math.sqrt(dx * dx + dy * dy);
			
			if (d < 95)
			{
				var wrong:Bool  = false;
				//Hit
				if (baseconf.indexOf(c.type) >= 0)
				{
					current.push(c.type);
				}
				else
				{
					wrong = true;
					//Wrong element.
					Main.instance.bg.filter.wrong();
					extra.push(c.type);
				}
				remove.push(c);
				cp.x += this.character.body.velocity.x * 20;
				cp.y += this.character.body.velocity.y * 20;
				if (!wrong)
				{
					Tween.get(c).to( { x:cp.x, y:cp.y }, 350, Ease.quadOut);
					Tween.get(c.scale).to( { x:0, y:0 }, 350, Ease.quadOut).call(function(){
						collectables.removeChild(c);
						updatePairs();
					});
				}
				else
				{
					Tween.get(c).to( { alpha:0 }, 350);
					Tween.get(c.scale).to( { x:1.5, y:1.5 }, 350, Ease.quadOut).call(function(){
						collectables.removeChild(c);
						updatePairs();
					});

				}
			}
			if (c.getBounds().y < -size.height)
			{
				remove.push(c);
				collectables.removeChild(c);
			}
		}
		for (c in remove) active.remove(c);
	}
	
	private function updatePairs():Void
	{
		var lc:Int = 0;
		var rc:Int = 0;
		var conf:Array<CType> = baseconf.slice(0);
		var removeFromCur:Array<CType> = [];
		var charge:Int = 0;
		for (c in current)
		{
			if (c == ui.target1.type) lc++;
			else if (c == ui.target2.type) rc++;
			if (conf.indexOf(c) >= 0)
			{
				conf.remove(c);
				removeFromCur.push(c);
			}
			
			if (c == CType.lithium) charge++;
			else if (c == CType.brohm) charge--;
			else if (c == CType.oxygen) charge-= 2;
			else if (c == CType.magnesium) charge+= 2;
			else if (c == CType.aluminium) charge+= 3;
		}
		this.ui.charge.updateCharge(charge);
		this.ui.target1.setcount(lc);
		this.ui.target2.setcount(rc);
		
		if (conf.length == 0)
		{
			for (c in removeFromCur) current.remove(c);
		}
		
		Timer.delay(function() { 
			
			//check if pair is formed.
			if (conf.length == 0)
			{
				requiredPairs--;
				
				updatePairs();
				//Animate pair forming
				ui.formPair(baseconf,requiredPairs);
				
				if (requiredPairs == 0 && !ending)
				{
					this.ending = true;
					Timer.delay(ui.hide, 4000);
					Tween.get(this.character).wait(1500,true).to( { alpha:0 }, 2500);
					Tween.get(this.collectables).wait(1500,true).to( { alpha:0 }, 2500);
					Tween.get(this.blocks).wait(1500,true).to( { alpha:0 }, 2500).wait(1500,true).call(endgame);
				}
			}
		},350 );
	}
	
	private function endgame():Void
	{
		ParticleManager.words.show();

		running = false;
		jar.randomize();
		this.jar.visible = true;
		Tween.get(this.jar).to( { alpha:1 }, 500);
	}
	
	public function hide():Void
	{
		Tween.get(this.jar).to( { alpha:0 }, 250);
	}
	
	private var xspawn:Array<Float> = [];
	private function spawnCollectable():Void
	{
		if (!ending && Math.abs(previousSpawn - charpos.y) > 100)
		{
			if (xspawn.length == 0)
			{
				for ( i in 0...20)
					xspawn.push(Math.random() / 20 + i * 1 / 20);
				xspawn = MathUtil.shuffle(xspawn, cast Date.now().getTime());
			}
			trace("spawn");
			previousSpawn = charpos.y;
			var c:Collectable = this.allCollectables[Math.floor(Math.random() * allCollectables.length)].getNext();
			this.collectables.addChild(c);
			c.scale.x = c.scale.y = 0.5;
			active.push(c);
			c.x = charpos.x + xspawn.pop() * size.width*2;
			
			c.y = charpos.y + size.height/Main.instance.viewport.scale.x;
		}
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		this.blocks.resize(size);
		jar.y = size.height / 2 / Main.instance.viewport.scale.x;
		jar.resize(size);
	}
}

typedef REACTION =
{
	public var instruction:String;
	public var conf:Array<CType>;
	public var final:String;
	public var compound:CompoundType;
}