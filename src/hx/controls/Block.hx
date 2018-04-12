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
	
	private static var blockType:Int = 0;
	private var type:Int;
	
	public function new(x:Float, y:Float) 
	{
		super();
		this.x = x;
		this.y = y;
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.type = (++blockType % 3 + 1) ;
		this.block = Asset.getImage("block_"+type+ ".png", true);
		
		this.block.anchor.x = this.block.anchor.y = 0.5;
		
		this.hitArea = new Rectangle( -block.width / 2, -block.height/2, block.width, block.height);
		
		this.addChild(this.block);
	}
	
	public function randomize(x:Float, y:Float):Void
	{
		this.scale.x = this.scale.y = 1;
		this.alpha = 1;
		this.block.rotation = (Math.random() - 0.5)*2.5;
		if (this.block.rotation < 0)
			this.block.rotation = Math.min( -0.6, this.block.rotation);
		else
			this.block.rotation = Math.max( -0.6, this.block.rotation);
	//	body = Bodies.rectangle(x, y, block.width, block.height, { isStatic:true, angle:block.rotation } );
		
		if (type == 1)
		{
			body = Bodies.fromVertices(x, y, [
			cast	{x:62, y:19},
			cast	{x:119, y:54},
			cast 	{x:137, y:119},
			cast 	{x:109, y:162},
			cast 	{x:46, y:140 },
			cast 	{x:32, y:82}
			], { isStatic:true, angle:block.rotation } );
		}
		else if (type == 2)
		{
			body = Bodies.fromVertices(x, y, [
			cast	{x:42, y:19},
			cast	{x:216, y:18},
			cast 	{x:246, y:37},
			cast 	{x:247, y:51},
			cast 	{x:227, y:69 },
			cast 	{ x:208, y:74 },
			cast 	{ x:30, y:74 },
			cast 	{x:14, y:49}
			], { isStatic:true, angle:block.rotation } );

		}
		else
		{
			body = Bodies.fromVertices(x, y, [
			cast	{x:76, y:25},
			cast	{x:123, y:53},
			cast 	{x:118, y:103},
			cast 	{x:58, y:113},
			cast 	{x:41, y:97 },
			cast 	{x:40, y:64}
			], { isStatic:true, angle:block.rotation } );
		}
	//	
	//	World.add(Main.instance.world, body);
		added = true;
		
		this.x = x;
		this.y = y;
		
		
	}
}