package controls;

import pixi.core.display.Container;
import pixi.core.text.Text;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Charge extends Container
{
	public var count:Text;
	
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		var ts:TextStyleObject = { };
		this.count = new Text("5", ts);
		
		this.addChild(this.count);
	}
	
}