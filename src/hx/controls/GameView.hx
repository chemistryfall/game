package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import js.Lib;
import matter.Body;
import matter.Vector;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import util.MathUtil;
import util.Pool;

/**
 * ...
 * @author Henri Sarasvirta
 */
class GameView extends Container
{
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
	
	public function new() 
	{
		super();
		
		this.oxygen = new Pool<Collectable>(10, function():Collectable { return new Collectable("oxygen.json"); } );
		this.lithium = new Pool<Collectable>(10, function():Collectable { return new Collectable("lithium.json"); } );
		this.magnesium = new Pool<Collectable>(10, function():Collectable { return new Collectable("magnesium.json"); } );
		this.aluminium = new Pool<Collectable>(10, function():Collectable { return new Collectable("aluminium.json"); } );
		this.brohm = new Pool<Collectable>(10, function():Collectable { return new Collectable("brohm.json"); } );
		
		this.allCollectables = [
			this.oxygen,
			this.lithium, 
			this.magnesium,
			this.aluminium,
			this.brohm
		];
		
		this.initializeControls();
		
		
	}
	
	public function applyCharMove(angle:Float):Void
	{
		if (angle < 0)
			angle = Math.max( -8, angle);
		else if (angle > 0)
			angle = Math.min( 8, angle);
		Body.applyForce(this.character.body, cast { x:0, y:0 }, cast { x:-angle / 15, y:0 } );
//		this.character.body.velocity.x += angle / 10;
//		this.character.body.velocity.x = Math.min(8, Math.max( -8, this.character.body.velocity.x));
		this.charpos.x += angle;
	}
	
	private function initializeControls():Void
	{
		this.collectables = new Container();
		this.character = new Character();
		
		this.blocks = new Blocks();
		this.addChild(this.blocks);
		this.addChild(this.collectables);
		this.addChild(this.character);
		
		Main.instance.tickListeners.push(onTick);
	}
	
	private function onTick(delta:Float):Void
	{
		time+= delta;
		
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
		
		
		this.blocks.update(charpos);
		this.spawnCollectable();
		
		this.collect();
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
			var  d:Float = Math.sqrt(dx * dx + dy * dy);
			
			if (d < 150)
			{
				remove.push(c);
				cp.x += this.character.body.velocity.x * 20;
				cp.y += this.character.body.velocity.y * 20;
				Tween.get(c).to( { x:cp.x, y:cp.y }, 350, Ease.quadOut);
				Tween.get(c.scale).to( { x:0, y:0 }, 350, Ease.quadOut).call(function(){
					collectables.removeChild(c);
				});
				
			}
			if (c.getBounds().y < -size.height)
			{
				remove.push(c);
				collectables.removeChild(c);
			}
		}
		for (c in remove) active.remove(c);
	}
	
	private function spawnCollectable():Void
	{
		if (Math.abs(previousSpawn - charpos.y) > 100)
		{
			trace("spawn");
			previousSpawn = charpos.y;
			var c:Collectable = this.allCollectables[Math.floor(Math.random() * allCollectables.length)].getNext();
			this.collectables.addChild(c);
			c.scale.x = c.scale.y = 0.5;
			active.push(c);
			c.x = charpos.x + (Math.random() - 0.5) * size.width;
			c.y = charpos.y + size.height;
		}
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		this.blocks.resize(size);
	}
}