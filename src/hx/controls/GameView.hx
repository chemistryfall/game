package controls;

import js.Lib;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import util.MathUtil;

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
	
	private var maxvelocity:Float = 40;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	public function applyCharMove(angle:Float):Void
	{
		if (angle < 0)
			angle = Math.max( -8, angle);
		else if (angle > 0)
			angle = Math.min( 8, angle);
		this.character.body.velocity.x += angle / 10;
		this.character.body.velocity.x = Math.min(8, Math.max( -8, this.character.body.velocity.x));
		this.charpos.x += angle;
	}
	
	private function initializeControls():Void
	{
		this.character = new Character();
		
		
		
		this.addChild(this.character);
		
		this.blocks = new Blocks();
		this.addChild(this.blocks);
		
		Main.instance.tickListeners.push(onTick);
	}
	
	private function onTick(delta:Float):Void
	{
		
		
	//	Main.instance.bg.charpos = Math.sin(time) * 300;
	//	charCircle.x = -charpos.x;
	//	charCircle.y = -charpos.y;
	//	var hit:ShapeCollision = blocks.checkHit(charCircle);
	//	if (hit != null)
	//	{
	//		dropSpeed = 0;
		//	charpos.x++;
	//		charpos.x += hit.unitVectorX;
			//charpos.y -= hit.unitVectorY;
			//charpos.x -= hit.separationX;
		//	trace(hit.unitVectorX + ", " + hit.unitVectorY + ", " + hit.otherUnitVectorX + ", " + hit.otherUnitVectorY);
	//	}
	//	else
	//		dropSpeed += Config.GRAVITY * delta;
	//	dropSpeed = Math.min( dropSpeed, 8);
		time+= delta;
		
		this.charpos.x = character.body.position.x;
		this.charpos.y = character.body.position.y;
		
		this.character.body.velocity.y = Math.max( -maxvelocity, Math.min(maxvelocity, this.character.body.velocity.y));
		
		Main.instance.bg.update(-charpos.x, -charpos.y);
		this.blocks.y = -charpos.y;
		this.blocks.x = -charpos.x;
		
		this.blocks.update(charpos);
	}
	
	public function resize(size:Rectangle):Void
	{
		this.blocks.resize(size);
	}
}