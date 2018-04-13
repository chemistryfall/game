package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.text.TextStyleObject;
import sounds.Sounds;
import util.Asset;
import controls.Compound.CompoundType;

/**
 * ...
 * @author Henri Sarasvirta
 */
class EndUi extends Container
{
	private var replay:Sprite;
	private var info:Sprite;
	private var infoLabel:Sprite;
	private var infoText:Text;
	private var infoC:Container;
	
	private var rating:Text;
	private var size:Rectangle;
	
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
		
		
		var ts:TextStyleObject = { };
		ts.wordWrap = false;
		//ts.wordWrapWidth = 400;
		ts.fontSize = 34;
		ts.align = "center";
		ts.fontFamily = 'pigment_demoregular';
		this.rating = new Text("Perfect!", ts);
		
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
		this.addChild(this.rating);
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
		this.size = size;
		this.info.x = size.width - info.width;
		this.info.y = 50;
		
		this.replay.x = 0;
		this.replay.y = 50;
		
		this.infoC.x = (size.width - infoC.width) / 2;
		this.infoC.y = size.height-infoC.height-10;
		
		this.rating.x = size.width / 2;
		this.rating.y = 300;
	}
	
	public function hide():Void
	{
		Tween.removeTweens(this.rating.scale);
		Tween.removeTweens(this.rating);
		Tween.get(this.rating.scale).to( { x:0, y:0 }, 300);
		this.visible = false;
	}
	
	public function show(rating:Int):Void
	{
		this.visible = true;
		
		//TODO - update compound text & position label
		if (GameView.CONF.compound == CompoundType.alu_bromide)
			this.infoText.text = "Aluminium bromide is any chemical compound with the empirical formula AlBr. Aluminium tribromide is the most common form of aluminium bromide.";
		else if (GameView.CONF.compound == CompoundType.alu_oxide)
			this.infoText.text = "Aluminium oxide is a chemical compound of aluminium and oxygen. It is the most commonly occurring of several aluminium oxides";
		else if (GameView.CONF.compound == CompoundType.lithium_bromide)
			this.infoText.text = "Lithium bromide is a chemical compound of lithium and bromine. Its extreme hygroscopic character makes LiBr useful as a desiccant in certain air conditioning systems.";
		else if (GameView.CONF.compound == CompoundType.lithium_oxide)
			this.infoText.text = "Lithium oxide or lithia is an inorganic chemical compound. It is a white solid. ";
		else if (GameView.CONF.compound == CompoundType.mag_bromide)
			this.infoText.text = "Magnesium bromide is a chemical compound of magnesium and bromine that is white and deliquescent. It is often used as a mild sedative and as an anticonvulsant for treatment of nervous disorders.";
		else if (GameView.CONF.compound == CompoundType.mag_oxide)
			this.infoText.text = "Magnesium oxide, or magnesia, is a white hygroscopic solid mineral that occurs naturally as periclase and is a source of magnesium.";
		
		infoLabel.width = infoText.width+10;
		infoLabel.height = infoText.height+10;
		infoText.x = 5;
		infoText.y = 5;
		
		this.infoC.x = (size.width - infoC.width) / 2;
		this.infoC.y = size.height-infoC.height-10;
		
		if (rating == 0) {
			this.rating.text = "Extra materials\ndetected.";
		}
		else if (rating == 1)
		{
			this.rating.text = "Ions not in\nequilibrium!";
		}
		else
			this.rating.text = "Perfect!";
			
		this.rating.scale.x = this.rating.scale.y = 1;
		this.rating.pivot.x = this.rating.width/2;
		this.rating.pivot.y = this.rating.height/2;
		
		this.rating.scale.x = this.rating.scale.y = 0;
		Tween.get(this.rating.scale).wait(2000,true).to( { x:1, y:1 }, 500, Ease.backOut);
		this.rating.rotation = 0.2;
		Tween.get(this.rating, { loop:true } ).to( { rotation: -0.2 }, 600, Ease.quadInOut)
		.to( { rotation:0.2 }, 600, Ease.quadInOut);
		
		Sounds.playEffect(Sounds.VICTORY, 0, 1, 2250);
	}
}