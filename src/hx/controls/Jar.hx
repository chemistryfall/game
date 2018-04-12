package controls;

import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Jar extends Container
{
	private var jar:Sprite;

	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.jar = Asset.getImage("jar_1.png", true);
		this.jar.anchor.x = 0.5;
		this.jar.anchor.y = 1;
		this.jar.scale.x = this.jar.scale.y = 0.6;
		
		this.addChild(this.jar);
	}
	
	public function resize(size:Rectangle):Void
	{
		this.jar.scale.x = this.jar.scale.y  = 1;
		var sw:Float = size.width / Main.instance.viewport.scale.x*0.75;
		var sh:Float = size.height / Main.instance.viewport.scale.x*0.75;
		var s:Float = Math.min(1, Math.min( sw / jar.width, sh / jar.height));
		this.jar.scale.x = this.jar.scale.y = s;
	}
	
}