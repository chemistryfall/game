package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import controls.Collectable.CType;
import controls.Compound.CompoundType;
import pixi.core.math.shapes.Rectangle;
import util.Pool;

/**
 * ...
 * @author Henri Sarasvirta
 */
class PairFormer extends Container
{
	private var oxygen:Pool<Collectable>;
	private var lithium:Pool<Collectable>;
	private var magnesium:Pool<Collectable>;
	private var aluminium:Pool<Collectable>;
	private var brohm:Pool<Collectable>;
	
	private var pools:Map<CType, Pool<Collectable>>;

	private var comAluBromide:Pool<Compound>;
	private var comAluOxide:Pool<Compound>;
	private var comLithiumBromide:Pool<Compound>;
	private var comLithiumOxide:Pool<Compound>;
	private var comMagBromide:Pool<Compound>;
	private var comMagOxide:Pool<Compound>;


	private var comPools:Map<CompoundType, Pool<Compound>>;
	
	private var size:Rectangle;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.oxygen = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.oxygen); } );
		this.lithium = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.lithium); } );
		this.magnesium = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.magnesium); } );
		this.aluminium = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.aluminium); } );
		this.brohm = new Pool<Collectable>(10, function():Collectable { return new Collectable(CType.brohm); } );
		
		this.pools = new Map<CType, Pool<Collectable>>();
		this.pools.set(CType.oxygen,oxygen);
		this.pools.set(CType.lithium,lithium);
		this.pools.set(CType.magnesium,magnesium);
		this.pools.set(CType.aluminium,aluminium);
		this.pools.set(CType.brohm, brohm);
		
		this.comAluBromide= new Pool<Compound>(10, function():Compound { return new Compound(CompoundType.alu_bromide); } );
		this.comAluOxide = new Pool<Compound>(10, function():Compound { return new Compound(CompoundType.alu_oxide); } );
		this.comLithiumBromide = new Pool<Compound>(10, function():Compound { return new Compound(CompoundType.lithium_bromide); } );
		this.comLithiumOxide = new Pool<Compound>(10, function():Compound { return new Compound(CompoundType.lithium_oxide); } );
		this.comMagBromide = new Pool<Compound>(10, function():Compound { return new Compound(CompoundType.mag_bromide); } );
		this.comMagOxide = new Pool<Compound>(10, function():Compound { return new Compound(CompoundType.mag_oxide); } );
		
		this.comPools = new Map<CompoundType, Pool<Compound>>();
		this.comPools.set(CompoundType.alu_bromide, comAluBromide);
		this.comPools.set(CompoundType.alu_oxide, comAluOxide);
		this.comPools.set(CompoundType.lithium_bromide, comLithiumBromide);
		this.comPools.set(CompoundType.lithium_oxide, comLithiumOxide);
		this.comPools.set(CompoundType.mag_bromide, comMagBromide);
		this.comPools.set(CompoundType.mag_oxide, comMagOxide);
		
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
	}
	
	public function formPairs(items:Array<CType>, left:CType, right:CType):Void
	{
		var cc:Int = 0;
		var cols:Array<Collectable> = [];
		for ( item in items)
		{
			var c:Collectable = this.pools.get(item).getNext();
			c.visible = true;
			this.addChild(c);
			cols.push(c);
			if (item == left)
			{
				c.x = 50;
				c.y = 50;
			}
			else
			{
				c.x = size.width - 50;
				c.y = 50;
			}
			var last:Bool = cc == items.length-1;
			c.visible = false;
			animateform(c, cols, last,cc, items);
			cc++;
		}
	}
	
	private function animateform(c:Collectable, cols:Array<Collectable>, last:Bool, cc:Int, items:Array<CType>):Void
	{
		Tween.get(c).wait(cc * 250 + 50, true).call(function() { 
				c.visible = true; 
				Tween.get(c.scale).to( { x:0.25, y:0.25 }, 500).wait(items.length*100-cc*80).to({x:0, y:0},1000);
				Tween.get(c.pivot).to( { 
					x: Math.sin(Math.PI * 2 * cc / items.length) * 200, 
					y:  Math.cos(Math.PI*2*cc/items.length)*200 
				}, 500).wait(items.length*100).to({x:0,y:0},250);
				Tween.get(c).to( {
					rotation:Math.PI / 2*16
				}, 750+250*items.length-cc*250,Ease.quadIn);
			} ).to( { 
				x:size.width / 2,
				y:125
			}, 250, Ease.quadOut).wait(500,true).call(function() {
				
				if (last)
				{
					for (cr in cols) Tween.get(cr).to( { alpha:0 }, 400);
					var com:Compound = this.comPools.get(GameView.CONF.compound).getNext();
					com.x = size.width / 2;
					com.y = 200;
					this.addChild(com);
					com.visible = true;
					com.alpha = 0;
					com.scale.x = com.scale.y = 0.7;
					Tween.get(com).to( { alpha:1 }, 250, Ease.quadOut).wait(750, true).to( { alpha:0 }, 500).call(function() { removeChild(com); } );
					Tween.get(com.scale).to( { x:1, y:1 }, 500, Ease.quadOut).wait(250,true).to( { x:1.3, y:1.3 }, 750, Ease.quadIn);
				}
			});
			
	}
}