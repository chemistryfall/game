package controls;

import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.text.TextStyleObject;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Help extends Container
{
	public var info:Sprite;
	public var helpJar:Sprite;
	private var helpText:Text;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.info = Asset.getImage("UI_info button.png", true);
		this.helpJar = Asset.getImage("instructions jar.png", true);
		
		this.info.interactive = true;
		this.helpJar.visible = false;
		info.scale.x = info.scale.y = 0.5;
		
		this.addChild(this.info);
		this.addChild(this.helpJar);
		
		var ts:TextStyleObject = { };
		ts.wordWrap = false;
		//ts.wordWrapWidth = 400;
		ts.fontSize = 36;
		ts.fontFamily = 'pigment_demoregular';
		this.helpText = new Text("Form 3 elements by collecting\nions. Make sure that you get\nthe charges correct!\nAvoid unneeded elements.\n\nControl by tilting phone in\nportrait mode.\nTap salts to destroy them.\n\nChemistry\n    Anni Kukko\nGraphics\n    Laura K. Horton\nMusic\n    Lauri\nCode\n    Henri Sarasvirta\n\n       EduGameJam 2018", ts);
		this.helpJar.addChild(this.helpText);
		
		this.helpText.x = 160;
		this.helpText.y = 280;
		
	}
	
	public function resize(size:Rectangle):Void
	{
		info.x = size.width - info.width;
		info.y = 0;
		
		helpJar.scale.x = helpJar.scale.y = 1;
		helpJar.scale.x = helpJar.scale.y = Math.min(1, Math.min((size.width - 50) / helpJar.width, (size.height - 50) / helpJar.height));
		this.helpJar.x = Math.round((size.width - this.helpJar.width) / 2);
		
		helpJar.y = size.height - helpJar.height;
		
	}
}
