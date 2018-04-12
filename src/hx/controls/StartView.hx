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
		this.start = Asset.getImage("start.png", true);
		
		this.start.y = 200;
		this.start.interactive = true;
		
		this.addChild(this.logo);
		this.addChild(this.start);
		
		this.origsize = this.getBounds();
	}
	
	public function resize(size:Rectangle)
	{
		this.scale.x = this.scale.y = 1;
		var s:Float = Math.min( (size.width-100) / origsize.width, (size.height-100) / origsize.height);
		this.scale.x = this.scale.y = s;
		
		this.x = Math.round((size.width - this.width) / 2);
	}
	
	public function hide():Void
	{
		Tween.get(this.logo).to( { y: -100, alpha:0 }, 500);
		Tween.get(this.start).to( { y: 100, alpha:0 }, 500);
		
	}
	
	public function show():Void
	{
		Tween.get(this.logo).to( { y:0, alpha:1 }, 500);
		Tween.get(this.start).to( { y: 200, alpha:1 }, 500);
	}
}