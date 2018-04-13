package controls;

import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.text.TextStyleObject;
import sounds.Sounds;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class EndUi extends Container
{
	private var replay:Sprite;
	private var info:Sprite;
	private var infoLabel:Sprite;
	private var infoText:Sprite;
	private var infoC:Container;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}

	private function initializeControls():Void
	{
		this.replay = Asset.getImage("UI_replay.png", true);
		this.info = Asset.getImage("UI_info button.png", true);
		this.infoLabel = Asset.getImage("help_bg.png", true);
		
		this.replay.scale.x = this.replay.scale.y = 0.5;
		this.info.scale.x = this.info.scale.y = 0.5;
		
		this.replay.interactive = true;
		
		var ts:TextStyleObject = { };
		ts.wordWrap = false;
		//ts.wordWrapWidth = 400;
		ts.fontSize = 24;
		ts.fontFamily = 'pigment_demoregular';
		this.infoText = new Text("Lithium oxide or lithia is an\ninorganic chemical compound.\nIt is a white solid.", ts);
		
		this.infoC = new Container();
		this.infoC.addChild(this.infoLabel);
		this.infoC.addChild(this.infoText);
		
		infoLabel.x = -0;
		infoLabel.y = -0;
		infoLabel.width = infoText.width;
		infoLabel.height = infoText.height;
		
		infoC.visible = false;
		
		info.interactive = true;
		info.addListener("click", onInfoclick);
		info.addListener("tap", onInfoclick);
		
		infoC.interactive = true;
		infoC.addListener("click", onInfoclick);
		infoC.addListener("tap", onInfoclick);
		
		replay.addListener("click", onreplay);
		replay.addListener("tap", onreplay);
		
		
		this.addChild(this.infoC);
		this.addChild(this.info);
		this.addChild(this.replay);
	}
	private function onreplay(e:Dynamic):Void
	{
		Main.instance.replay();
		Sounds.playEffect(Sounds.TOGGLE);
	}
	
	private function onInfoclick(e:Dynamic):Void
	{
		this.infoC.visible = !infoC.visible;
		Sounds.playEffect(Sounds.TOGGLE);
	}
	
	public function resize(size:Rectangle):Void
	{
		this.info.x = size.width - info.width;
		this.info.y = 50;
		
		this.replay.x = 0;
		this.replay.y = 50;
		
		this.infoC.x = (size.width - infoC.width) / 2;
		this.infoC.y = size.height-infoC.height-10;
		
	}
	
	public function hide():Void
	{
		
		this.visible = false;
	}
	
	public function show():Void
	{
		this.visible = true;
		
		//TODO - update compound text & position label
	}
}