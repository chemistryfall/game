package controls;

import pixi.core.display.Container;
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
		this.addChild(this.jar);
	}
	
}