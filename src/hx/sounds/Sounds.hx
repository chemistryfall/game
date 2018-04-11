package sounds;
import createjs.Event;
import createjs.soundjs.AbstractSoundInstance;
import createjs.soundjs.Sound;
import createjs.tweenjs.Tween;
import haxe.ds.StringMap.StringMap;
import haxe.Json;
import haxe.Resource;
import js.Browser;
import js.Lib;
import js.RegExp;
import util.BrowserDetect;


/**
* Simple sound manager for sounds.
*/
class Sounds
{
	/**
	 * Possible sounds. Mapped to id.
	 */
	
	public static var WIN:String = "win";
	public static var LOSE:String = "loss";

	
	public static var BACKGROUND:String = "background";

	private static var bg_volume:Float = 1;
	
	
	/**
	 * Public properties
	 */
	public static var totalSounds:Int = 0;
	public static var loadedHandler:Dynamic;
	public static var loadChange:Int->Void;
	
	/**
	* Private properties of the class.
	*/
	private static var soundMap:StringMap<AbstractSoundInstance>;
	private static var loaded:Array<String>;
	private static var sounds:Array<Dynamic>;
	private static var initok:Bool = false;
	public static var soundsLoaded:Int = 0;
	private static var waitingForIOS:Bool = false;
	
	private static var ingame:Bool = false;
	
	/**
	* Initializes the background sound.
	* @param framework A reference to the framework.
	*/
	static public function initSounds():Bool
	{
		Sound.addEventListener("fileload", soundLoadHandler);
		loaded = [];
		
		soundMap = new StringMap();
		
		var base:String = "snd/";
		Sound.alternateExtensions = ["mp3"];
		
		sounds = [
			{s:BACKGROUND, c:1 }
		];
		
		//Load single sounds
		for (s in sounds)
		{
			Sound.registerSound(base + s.s+".ogg", s.s, s.c);
		}
		
		//Listen for ios unlock. Soundjs does the initial unlocking automatically in 6.2 and forwards. This is used to start bg loop.
		var iOS = new RegExp("iPad|iPhone|iPod").test(Browser.navigator.userAgent) && !untyped Browser.window.MSStream;
		if (iOS)
		{
			waitingForIOS = true;
			Browser.window.addEventListener("click", handleInitClick, true);
			Browser.window.addEventListener("touchstart", handleInitClick, true);
		}
		
		initok = true;
		
		//Skip sound preload
		totalSounds = 0;
		
		return true;
	}
	
	/**
	 * Sound loaded handler
	 * @param	e
	 */
	private static function soundLoadHandler(e:Event):Void
	{
		soundsLoaded++;
		if (loadChange != null) loadChange(soundsLoaded);
		if (untyped e.id != null)
		loaded.push(untyped e.id);
		
		if (untyped e.id == Sounds.BACKGROUND && !Sound.getMute() && !waitingForIOS && !ingame)
		{
			Sounds.playEffect(Sounds.BACKGROUND, -1,bg_volume);
		}
	
		if (soundsLoaded == totalSounds && loadedHandler != null)
		{
			loadedHandler();
		}
	}
	
	/**
	* Enables sound after user touches the mainWrapper on iOS.
	* @param event The recieved click event.
	*/
	static private function handleInitClick(event:Dynamic):Void
	{
		waitingForIOS = false;
		Browser.window.removeEventListener("touchstart", handleInitClick, true);
		Browser.window.removeEventListener("click", handleInitClick, true);
		if (!Sound.getMute())
		{
			if(loaded.indexOf(BACKGROUND)>=0)
				Sounds.playEffect(Sounds.BACKGROUND, -1, bg_volume);
		}
	}
	
	/**
	 * Plays given sound
	 * @param	name Name of the sound. All sounds are defined as static fields in Sounds.
	 * @param	?loops Amount of loops. Defaults to 1. -1 for infinite.
	 * @param	?volume Volume for the sound. Defaults to 1.
	 * @param	?delay Delay for sound. Defaults to 0.
	 */
	static public function playEffect(name:String,?loops:Int, ?volume:Float, ?delay:Float):AbstractSoundInstance
	{
		if (!Sound.getMute() && initok && Sounds.soundRegistered(name))
		{
			if (volume == null)
				volume = 1;
			if (loops == null)
				loops = 0;
			if (delay == null)
				delay = 0;
			soundMap.set(name, Sound.play(name, {delay:delay, interrupt: Sound.INTERRUPT_ANY, loop:loops, volume:volume}));
		}
		return soundMap.get(name);
	}
	
	static public function soundRegistered(name:String):Bool
	{
		return Reflect.hasField(Sound._idHash, name);
	}
	
	/**
	 * Stops a sound if such exists.
	 * @param	name
	 */
	static public function stopSound(name:String):Void
	{
		if (soundMap.exists(name))
			soundMap.get(name).stop();
	}
	
	static public function getSound(name:String):AbstractSoundInstance
	{
		return soundMap.get(name);
	}
	
	/**
	* Plays the background sound and loops it.
	*/
	static public function enableSounds():Void
	{
		if (Sound.getMute() && initok) 
		{
			Sound.setMute(false);
				Sounds.stopSound(BACKGROUND);
				if(loaded.indexOf(Sounds.BACKGROUND)>=0 )
					Sounds.playEffect(Sounds.BACKGROUND, -1, bg_volume);
		}
	}
	
	/**
	* Pauses the background sound by stopping all sounds.
	*/
	static public function disableSounds():Void
	{
		Sound.setMute(true);
	}
	
}
