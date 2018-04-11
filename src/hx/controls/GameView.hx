package controls;

import pixi.core.display.Container;

/**
 * ...
 * @author Henri Sarasvirta
 */
class GameView extends Container
{
	private var character:Character;
	private var time:Float = 0;

	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.character = new Character();
		this.addChild(this.character);
		
		Main.instance.tickListeners.push(onTick);
	}
	
	private function onTick(delta:Float):Void
	{
		Main.instance.bg.charpos = Math.sin(time) * 300;
		
		time+= delta / 60;
	}
}