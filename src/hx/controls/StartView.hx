package controls;

import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import sounds.Sounds;
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
	private var help:Help;
	
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
		
		this.help = new Help();
		this.addChild(this.help);
		this.help.info.addListener("click", onHelpClick);
		this.help.info.addListener("tap", onHelpClick);
		
		this.origsize = this.getBounds();
	}
	
	private function onHelpClick(e:Dynamic):Void
	{
		this.logo.visible = !this.logo.visible;
		this.help.helpJar.visible = !this.help.helpJar.visible;
		Sounds.playEffect(Sounds.TOGGLE);
	}
	
	public function resize(size:Rectangle)
	{
		this.scale.x = this.scale.y = 1;
		var s:Float = Math.min( (size.width-50) / origsize.width, (size.height-50) / origsize.height);
		this.logo.scale.x = this.logo.scale.y = s;
		this.logo.y = (size.height) -logo.height;
		
		this.logo.x = Math.round((size.width - this.logo.width) / 2);
		
		this.help.resize(size);
	}
	
	public function hide():Void
	{
		Tween.get(this.logo).to( {  alpha:0 }, 450);
		Tween.get(this.start).to( { alpha:0 }, 450);
		Tween.get(this.help).to( { alpha:0 }, 450);
		
	}
	
	public function show():Void
	{
		Tween.get(this.logo).to( { alpha:1 }, 500);
		Tween.get(this.start).to( { alpha:1 }, 500);
		Tween.get(this.help).to( { alpha:1 }, 500);
	}
}