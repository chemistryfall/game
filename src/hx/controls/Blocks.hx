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
		this.composite = Composite.create( { } );
		World.add(Main.instance.world, this.composite);
		this.pool = new Pool<Block>(50, function():Block { 
			var b:Block = new Block(0, -999);
			b.visible = false;
			this.addChild(b);
			return b;
		} );
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
			if (composite.bodies.indexOf(b.body) >= 0) composite.bodies.remove(b.body);
			b.randomize(charpos.x + (Math.random() - 0.5) * size.width, charpos.y + size.height);
			composite.bodies.push(b.body);
			b.visible = true;
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