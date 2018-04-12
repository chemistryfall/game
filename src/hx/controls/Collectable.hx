package controls;

import haxe.Timer;
import pixi.core.display.Container;
import pixi.core.textures.Texture;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
enum CType
{
	oxygen;
	lithium;
	aluminium;
	magnesium;
	brohm;
}
 
class Collectable extends Container
{
	private var ac:AnimationController;
	public var type:CType;
	
	private var idleTimer:Timer;
	
	public function new(type:CType) 
	{
		super();
		this.type = type;
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		var idle:Array<Texture> = Asset.getTextures( Asset.getResource("img/"+type.getName()+".json").data, new EReg("Idle/.*", ""));
		var blink:Array<Texture> = Asset.getTextures( Asset.getResource("img/"+type.getName()+".json").data, new EReg("Blink/.*", ""));
		
		var textures:Array<Array<Texture>> = [idle, blink];
		this.ac = new AnimationController(textures, ["idle", "blink"]);
		
		this.addChild(this.ac);
		this.ac.gotoAndPlay("idle");
		this.ac.loop = true;
		this.ac.animationSpeed = 5/ 60;
		
		this.scale.x = this.scale.y = 0.5;
		
		this.restartTimer();
	}
	
	private function restartTimer():Void
	{
		if (this.idleTimer != null) this.idleTimer.stop();
		this.idleTimer = new Timer(Math.floor(Math.random() *3+1)* 500);
		this.idleTimer.run = ontick;
	}
	
	private function ontick():Void
	{
		this.ac.gotoAndPlay("blink");
		restartTimer();
		Timer.delay(function() { this.ac.gotoAndPlay("idle"); }, Math.floor(100+Math.floor(Math.random()*100) ));
	}
	
}