package controls;


import matter.Composite;
import matter.World;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import util.Pool;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Blocks extends Container
{
	private var composite:Composite;
	private var pool:Pool<Block>;
	private var blocks:Array<Block>;
	private var size:Rectangle = new Rectangle(0,0,100,100);
	
	private var previousSpawn:Float = 0;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
	//	this.composite = Composite.create( { } );
	//	World.add(Main.instance.world, this.composite);
		this.pool = new Pool<Block>(50, function():Block { 
			var b:Block = new Block(0, -999);
			b.visible = false;
			b.interactive = true;
			b.addListener("click", onBlockClick);
			b.addListener("tap", onBlockClick);
			this.addChild(b);
			return b;
		} );
	}
	
	private function onBlockClick(e:Dynamic):Void
	{
		var b:Block = e.currentTarget;
		if (b.body == null) return;
		trace("Remove body");
		
		untyped World.remove(Main.instance.world, b.body);
		b.body = null;
		b.visible = false;
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
	}
	
	public function update(charpos:Point):Void
	{
		if (Math.abs(previousSpawn - charpos.y) > 100)
		{
			previousSpawn = charpos.y;
			var b:Block = pool.getNext();
			
			if(b.body != null)
				untyped World.remove(Main.instance.world, b.body);
			b.randomize(charpos.x + (Math.random() - 0.5) * size.width*2, charpos.y + size.height/Main.instance.viewport.scale.x);
		//	Composite.add(composite, b.body);
			World.add(Main.instance.world, b.body);
			b.visible = true;
		}
		for (b in pool.all)
		{
			if (b.body != null)
			{
		//		b.x = b.body.position.x;
		//		b.y = b.body.position.y;
		//		b.rotation = b.body.angle;
			}
		}
	}
	
	/*
	public function checkHit( circle:Circle):ShapeCollision
	{
		for (b in blocks)
		{
			var c:ShapeCollision = Collision.shapeWithShape(circle, b.box);
			if(c != null)
				return c;
		}
		return null;
	}*/
}