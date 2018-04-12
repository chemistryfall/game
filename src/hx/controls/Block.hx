package controls;

import matter.Bodies;
import matter.Body;
import matter.World;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Block extends Container
{
	public var body:Body;
	
	private var block:Sprite;
	public var added:Bool = false;
	
	public function new(x:Float, y:Float) 
	{
		super();
		this.x = x;
		this.y = y;
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.block = Asset.getImage("block.png", true);
		this.block.anchor.x = this.block.anchor.y = 0.5;
		
		this.hitArea = new Rectangle( -block.width / 2, -block.height, block.width, block.height * 2);
		
		this.addChild(this.block);
	}
	
	public function randomize(x:Float, y:Float):Void
	{
		this.block.rotation = (Math.random() - 0.5)*2.5;
		if (this.block.rotation < 0)
			this.block.rotation = Math.min( -0.6, this.block.rotation);
		else
			this.block.rotation = Math.max( -0.6, this.block.rotation);
		body = Bodies.rectangle(x, y, block.width, block.height, { isStatic:true, angle:block.rotation } );
	//	
	//	World.add(Main.instance.world, body);
		added = true;
		
		this.x = x;
		this.y = y;
		
		
	}
}