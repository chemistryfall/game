package;
import controls.Background;
import controls.DeviceOrientationControl;
import controls.GameView;
import controls.StartView;
import createjs.soundjs.Sound;
import createjs.tweenjs.Tween;
import haxe.Timer;

import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import js.Lib;
import js.html.Element;
import js.html.TouchEvent;
import js.jquery.JQuery;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.Pixi;
import pixi.core.renderers.Detector;
import pixi.core.renderers.SystemRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.ticker.Ticker;
import sounds.Sounds;
import util.Asset;
import util.BrowserDetect;
import util.LoaderWrapper;

/**
* Main class of the game UI.
* @author Moido Games
*/
@:expose("Game")
class Main
{
	/**
	 * Instance to gameui for easy access of framework
	 */
	public static var instance:Main;
	
	/**
	 * List of functions to be called whenever render triggers.
	 */
	public var tickListeners:Array < Float->Void > = [];
	
	/**
	* Private properties of the class.
	*/
	private var resizeTimer:Timer;
	private var container:DivElement;
	private var mainCanvas:CanvasElement;
	private var mainContainer:Container;
	private var viewport:Container;
	
	private var ticker:Ticker;
	
	private var bg:Background;
	private var game:GameView;
	private var start:StartView;
	/**
	 * Renderer for the game.
	 */
	public var renderer(default,null):SystemRenderer;
	
	/**
	* Entry point of the application.
	*/
	static public function main():Void
	{
		trace("Main");
		new JQuery().ready(function() { 
			instance = new Main();
		} );
	}
	
	/**
	* Creates an new instance of the class.
	*/
	public function new():Void
	{
		trace("new game");
		//Clear ticker from createjs/tweenjs as custom one is used and this would collide with tweens.
		//This was added due to tweenjs Ticker bug. Ticker was on even though it was stopped.
		//Check on next version of tweenjs if this has been resolved.
		untyped createjs.Ticker = null;
		
		//Wrap pixijs loader around fw loader.
		LoaderWrapper.LOAD_ASSETS( Config.ASSETS, onAssetsLoaded);
		Sounds.initSounds();
	}
	
	/**
	 * Assets loaded handler
	 */
	private function onAssetsLoaded():Void
	{
		this.initializeRenderer();
		this.initializeControls();
		Browser.window.addEventListener("resize", this.onResize, false);
		Browser.window.addEventListener("orientationchange", this.onResize, false);
	}
	
	/**
	* After a resize event, throttle it and then resize the required elements.
	* @param event The recieved resize event.
	*/
	private function onResize(event:Dynamic):Void
	{
		if (this.resizeTimer != null) this.resizeTimer.stop();
		this.resizeTimer = Timer.delay(function()
		{
			var size:Rectangle = this.getGameSize();
			
			this.bg.resize(size);
			this.renderer.resize(size.width, size.height);
			
			this.viewport.x = size.width / 2;
			this.viewport.y = size.height / 2;
		},
		50);
	}
	
	/**
	* Gets the correct size of the game. IPhone may offset height and the size is fixed for WP7 devices.
	* This does not use frameworks viewmanager size on purpose. As the game is designed to play on ticket 
	* pages as well as normal ticket.
	* @return The size of the game.
	*/
	public function getGameSize():Rectangle
	{
		return new Rectangle(0, 0, Browser.window.innerWidth, Browser.window.innerHeight);
	}
	
	private function initializeRenderer():Void
	{
		var size:Rectangle = this.getGameSize();
		
		var options:RenderingOptions = { };
		options.autoResize = false;
		options.antialias = true;
		options.backgroundColor = 0x0;
		options.clearBeforeRender = true;
		options.preserveDrawingBuffer = false;
		options.roundPixels = false;
		
		this.renderer = Detector.autoDetectRenderer(size.width, size.height, options);
		
		Browser.document.getElementById("game").appendChild(renderer.view);
	}
	
	/**
	* Initializes the main controls used in the game UI.
	* @param container The container where to add the canvas.
	*/
	private function initializeControls():Void
	{
		this.mainContainer = new Container();
		
		this.bg = new Background();
		this.game = new GameView();
		this.start = new StartView();
		
		this.viewport = new Container();
		this.bg.addChild(this.start);
		this.bg.addChild(this.game);
		this.viewport.addChild(this.bg);
		this.mainContainer.addChild(this.viewport);
		
		this.viewport.pivot.x = 1024;
		this.viewport.pivot.y = 1024;
		
		this.onResize(null);
		
		this.ticker = new Ticker();
		this.ticker.start();
		this.ticker.add(onTickerTick);
		
		DeviceOrientationControl.initialize();
	}
	
	/**
	* Updates the stage on Ticker tick.
	* @param event The recieved tick event.
	*/
	private function onTickerTick():Void
	{
		var delta:Float = ticker.deltaTime;
		Tween.tick(ticker.elapsedMS,false);
		for (t in tickListeners) t(delta);
		
		this.renderer.render(this.mainContainer);
	}
	
	public function updateRotation(rot:Float):Void
	{
		this.viewport.rotation = rot;
	}
}
