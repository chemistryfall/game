package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import util.Asset;
import controls.Collectable.CType;
/**
 * ...
 * @author Henri Sarasvirta
 */
class UI extends Container
{
	public var target1:TargetIndicator;
	public var target2:TargetIndicator;
	private var charge:Charge;
	private var former:PairFormer;
	
	private var size:Rectangle;
	private var reaction:Sprite;
	private var finalReaction:Sprite;
	private var reactionlabel:Sprite;
	private var finalreactionlabel:Sprite;
	
	private var reactionC:Container;
	private var finalReactionC:Container;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.target1 = new TargetIndicator(true);
		this.target2 = new TargetIndicator(false);
		this.charge = new Charge();
		
		this.target1.count.x = 44;
		this.target2.count.x = 44;
		this.target1.count.y = 80;
		this.target2.count.y = 80;
		
		this.addChild(this.charge);
		this.addChild(this.target1);
		this.addChild(this.target2);
		
		this.former = new PairFormer();
		this.addChild(this.former);
		
		this.finalreactionlabel = Asset.getImage("label.png", true);
		this.reactionlabel = Asset.getImage("label.png", true);
		
		this.finalReactionC = new Container();
		this.reactionC = new Container();
		
		this.finalReactionC.addChild(this.finalreactionlabel);
		this.reactionC.addChild(this.reactionlabel);
		
		reactionlabel.y = -70;
		finalreactionlabel.y = -70;
		
		this.addChild(this.reactionC);
		this.addChild(this.finalReactionC);
		
		this.finalReaction = Asset.getImage("alumiinibromidin_reaktio.png", true);
		this.reaction = Asset.getImage("alumiinibromidin_reaktio.png", true);
		this.reactionC.addChild(this.reaction);
		this.finalReactionC.addChild(this.finalReaction);
		this.reactionC.pivot.y = 100;
		this.charge.pivot.y = 100;
		this.finalReactionC.pivot.y = 100; 
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		this.target2.x = size.width - 100;
		this.reaction.width = size.width - 100;
		this.reaction.height = 50;
		this.reaction.scale.x = this.reaction.scale.y = Math.min(1, Math.min(this.reaction.scale.y, this.reaction.scale.x));
		this.reactionlabel.width = this.reaction.width * 2;
		this.reaction.x = (reactionlabel.width - reaction.width) / 2;
		this.reactionC.x = Math.round((size.width - reactionC.width) / 2);
		
		this.finalReaction.width = size.width - 100;
		this.finalReaction.height = 50;
		this.finalReaction.scale.x = this.finalReaction.scale.y = Math.min(1, Math.min(this.finalReaction.scale.y,this.finalReaction.scale.x));
		this.finalreactionlabel.width = this.finalReaction.width*2;
		this.finalReaction.x = (finalreactionlabel.width - finalReaction.width) / 2;
		this.finalReactionC.x = Math.round((size.width - finalReactionC.width) / 2);
		
		this.charge.x = size.width / 2;
		this.former.resize(size);
	}
	
	public function start(reaction:String, finalReaction:String):Void
	{
		this.target1.start();
		this.target2.start();
		this.reaction.texture = Asset.getTexture(reaction, true);
		this.finalReaction.texture = Asset.getTexture(finalReaction, true);
		this.resize(size);
		Tween.get(this.reactionC.pivot).to( { y:0 }, 450, Ease.backOut);
		Tween.get(this.charge.pivot).to( { y: -60 }, 450, Ease.backOut);
		Tween.get(this.finalReactionC.pivot).to( { y:100 }, 450, Ease.backOut);
	}
	
	public function hide():Void
	{
		Tween.get(this.charge.pivot).to( { y: 100 }, 450, Ease.backOut);
		this.target1.hide();
		this.target2.hide();
		Tween.get(this.reactionC.pivot).to( { y:100 }, 450, Ease.backOut);
		Tween.get(this.finalReactionC.pivot).to( { y:0 }, 450, Ease.backOut);
	}
	
	public function updatePairAmount(pairsNeeded:Int):Void
	{
		this.charge.count.text = Std.string(Math.max(0, pairsNeeded));
	}
	
	public function formPair(items:Array<CType>, pairsNeeded:Int):Void
	{
		this.charge.count.text = Std.string(Math.max(0, pairsNeeded));
		this.former.formPairs(items, this.target1.type, this.target2.type);
	}
	
}