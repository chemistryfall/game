package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import controls.Collectable.CType;
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
		
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
	}
	
	public function formPairs(items:Array<CType>, left:CType, right:CType):Void
	{
		var cc:Int = 0;
		for ( item in items)
		{
			var c:Collectable = this.pools.get(item).getNext();
			c.visible = true;
			this.addChild(c);
			
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
			Tween.get(c).to( { x:size.width / 2, y:100 }, 350 + cc * 100, Ease.quadOut).call(function(){
				c.visible = false;
			});
			
			cc++;
		}
	}
}