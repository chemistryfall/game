package controls;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.text.TextStyleObject;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Charge extends Container
{
	public var count:Text;
	private var beaker:Sprite;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.beaker = Asset.getImage("corner beaker.png", true);
		this.beaker.scale.x =  this.beaker.scale.y = 0.4;
		this.beaker.anchor.x = 0.5;
		
		var ts:TextStyleObject = { };
		ts.fontSize = 70;
		this.count = new Text("5", ts);
		this.count.x = -this.count.width / 2-6;
		this.count.y = 50;
		this.beaker.addChild(this.count);
		
		this.addChild(this.beaker);
	}
	
}