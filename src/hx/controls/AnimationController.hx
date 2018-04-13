package controls;

import haxe.ds.StringMap;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;


/**
 * Modified version of pixi.js animatedSprite. Allows multiple animations and sequences.
 */
class AnimationController extends Sprite 
{
	public static var ON_COMPLETE:String = "onComplete";
	public static var ON_CHANGE:String = "onChange";
	
	/**
	 * Should the animation loop
	 */
	public var loop:Bool = false;
	/**
	 * Speed of the animation. Lower number means slower.
	 * 1 = 60fps. 0.5 = 30 fps. etc.
	 */
	public var animationSpeed:Float = 1;
	/**
	 * Is the animation playing.
	 */
	public var playing:Bool = false;

	public var currentFrame:Int;
	public var frameCount:Int = 0;
	public var currentAnimation:String;
	public var loopCount:Int;
	public var targetLoop:Int = 0;
	
	private var _textures:Array<Texture>;
	private var _textureMap:StringMap<Array<Texture>>;
	private var _durations:Dynamic;
	private var _currentTime:Float = 0;
	
	private var _currentAnimation:String;
	
	public var frameListeners:Array<FrameTrigger> = [];
	
	/**
	 * How many frames should be delayed before next animation starts
	 */
	private var frameDelay:Int = 0;
	
	/**
	 * Delay how much instant frames should be offset on trigger calculations.
	 */
	public var instantDelay:Int = 0;
	
	private var queuAnimation:String;
	private var queuFrame:Int;
	
	private var _delay:Float = 0;
	
	//Sheet used in the animation. This should only be used in editor.
	public var sheet:String = null;
	
	private var _queu:Array<String> = [];
	
	/**
	 * @param	textures List of textures for each animation
	 * @param	animations Animation id's
	 */
	public function new(textures:Array<Array<Texture>>, animations:Array<String>, ?name:String) 
	{
		super(textures == null || textures.length == 0 ? null : textures[0][0]);
		this._textureMap = new StringMap<Array<Texture>>();
		for ( i in 0...animations.length)
		{
			if (textures == null || textures[i] == null || textures[i].length == 0) continue;
			this._textureMap.set(animations[i], textures[i]);
		}
		
		this.currentAnimation = animations[0];
		this.currentFrame = 0;
		this.animationSpeed = 0.5;
		this.updateTextures();
	}
	
	public function changeAnimations(textures:Array<Array<Texture>>, animations:Array<String>):Void
	{
		this.frameDelay = 0;
		this.frameListeners = [];
		this._textureMap = new StringMap<Array<Texture>>();
		for ( i in 0...animations.length)
		{
			if (textures == null || textures[i] == null || textures[i].length == 0) continue;
			this._textureMap.set(animations[i], textures[i]);
		}
		this.currentAnimation = animations[0];
		this.currentFrame = 0;
		this.updateTextures(true);
	}
	
	public function stop():Void
	{
		if (!this.playing) return;
		this.playing = false;
		Main.instance.tickListeners.remove(this.update);
	}
	
	public function play():Void
	{
		if (this.playing) return;
		this.playing = true;
		Main.instance.tickListeners.push(this.update);
	}
	
	public function playAll():Void
	{
		this.loop = false;
		this._queu = [];
		for (key in this._textureMap.keys())
		{
			this._queu.push(key);
		}
		if (this._queu.length > 0)
		{
			gotoAndPlay(this._queu[0]);
		}
	}
	
	private function nextQueu():Void
	{
		if (this._queu.length > 0)
		{
			gotoAndPlay(this._queu[0]);
		}
		else
		{
		//	gotoAndStop("default");
		}
	}
	
	public function gotoAndStop(animation:String, ?frame:Int):Void
	{
		this.frameListeners = [];
		this.loopCount = 0;
		this.frameDelay = 0;
		this.stop();
		if (frame == null) frame = 0;
		this._currentTime = frame;
		if (frame != this.currentFrame || (animation != this.currentAnimation || animation == null))
		{
			this.currentFrame = frame;
			if(animation != null)
				this.currentAnimation = animation;
			this.updateTextures();
		}
	}
	
	public function gotoAndPlay(animation:String, ?frame:Int, ?frameDelay:Int):Void
	{
		Main.instance.tickListeners.remove(this.frameDelayHandler);
		if (frameDelay != null && frameDelay > 0)
		{
			_delay = 0;
			this.frameDelay = frameDelay;
			this.queuAnimation = animation;
			this.queuFrame = frame;
			//Temporarily set the playing to be true as play is in queu.
			this.playing = true;
			Main.instance.tickListeners.push(this.frameDelayHandler);
		}
		else
		{
			this.stop();
			this.frameListeners = [];
			this.loopCount = 0;
			this.queuAnimation = null;
			this.queuFrame = null;
			this.frameDelay = 0;
			this._delay = 0;
			if (frame == null) frame = 0;
			this._currentTime = frame;
			if (frame != this.currentFrame || animation != this.currentAnimation)
			{
				this.currentFrame = frame;
				this.currentAnimation = animation;
				this.updateTextures();
			}
			this.play();
		}
	}
	
	private function frameDelayHandler(delta:Float):Void
	{
		var elapsed:Float = this.animationSpeed * delta;
		
		//Calculate frame delays
		if (frameDelay > 0)
		{
			this._delay += elapsed;
			if (_delay >= frameDelay)
			{
				var curListeners:Array<FrameTrigger> = this.frameListeners;
				this.stop();
				this.gotoAndPlay(queuAnimation, queuFrame);
				this.frameListeners = curListeners;
				return;
			}
		}
	}
	
	private function update(delta:Float):Void
	{
		//Update textures
		if (this._textures == null) return;
		
		var elapsed:Float = this.animationSpeed * delta;
		
		this._currentTime += elapsed;
		var targetFrame:Int = Math.floor(this._currentTime);
		
		if (targetFrame >= this._textures.length)
		{
			if (this.loop && this.targetLoop <= 0 || this.targetLoop < this.loopCount)
			{
				this._currentTime-= this._textures.length;
				this.loopCount++;
			}
			else
			{
				targetFrame = this._textures.length - 1;
				this.stop();
			}
			if (this.frameDelay <= 0)
			{
				this.emit(ON_COMPLETE, this);
				this.nextQueu();
			}
		}
		
		if (targetFrame != this.currentFrame)
		{
			this.currentFrame = targetFrame;
			this.updateTextures();
			this.emit(ON_CHANGE, this);
		}
		
		for ( flag in frameListeners)
		{
			if (_currentAnimation.indexOf(flag.animation) == -1) continue;
			
			var test:Int = currentFrame;
			if (_currentAnimation.indexOf("instant") >= 0) test -= instantDelay;
			
			if (test >= flag.frame)
			{
				flag.handler(test, this);
				frameListeners.remove(flag);
			}
		}
	}
	
	public function updateTextures(?force:Bool):Void
	{
		if (this.currentAnimation != this._currentAnimation || force)
		{
			var nextTextures = this._textureMap.get(this.currentAnimation);
			this._currentAnimation = currentAnimation;
			if (nextTextures == null || nextTextures.length == 0){
				this.visible = false;
			//	this.tint = 0xff0000;
			trace("Anim " + this.currentAnimation + " not found");
				return;
			}
			
			//this.tint = 0xffffff;
			this.visible = true;
			this._textures = nextTextures;
			
		}
		this.frameCount = this._textures.length;
		this.currentFrame = this.currentFrame >= this._textures.length ? this._textures.length - 1 : this.currentFrame;	
		this.texture = this._textures[this.currentFrame];
		this.anchor.x = this.anchor.y = 0.5;
	}
	
}

typedef FrameTrigger = {
	public var frame:Int;
	public var handler:Int->AnimationController->Void;
	public var animation:String;
}