package controls;

import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class StartView extends Container
{
	private var logo:Sprite;
	public var start:Sprite;

	private var origsize:Rectangle;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.logo = Asset.getImage("logo.png", true);
		this.start = Asset.getImage("start_button.png", true);
		
		this.start.y = 720;
		this.start.x = 110;
		this.start.interactive = true;
		
		this.addChild(this.logo);
		this.logo.addChild(this.start);
		
		this.origsize = this.getBounds();
	}
	
	public function resize(size:Rectangle)
	{
		this.scale.x = this.scale.y = 1;
		var s:Float = Math.min( (size.width-50) / origsize.width, (size.height-50) / origsize.height);
		this.scale.x = this.scale.y = s;
		this.logo.y = (size.height) / s-logo.height;
		
		this.x = Math.round((size.width - this.width) / 2);
	}
	
	public function hide():Void
	{
		Tween.get(this.logo).to( {  alpha:0 }, 450);
		Tween.get(this.start).to( { alpha:0 }, 450);
		
	}
	
	public function show():Void
	{
		Tween.get(this.logo).to( { y:0, alpha:1 }, 500);
		Tween.get(this.start).to( { y: 200, alpha:1 }, 500);
	}
}