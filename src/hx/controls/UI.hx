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
		
		this.reaction = Asset.getImage("alumiinibromidin_reaktio.png", true);
		this.addChild(this.reaction);
		this.reaction.pivot.y = 100;
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		this.target2.x = size.width - 100;
		this.reaction.width = size.width - 100;
		this.reaction.height = 50;
		this.reaction.scale.x = this.reaction.scale.y = Math.min(1, Math.min(this.reaction.scale.y,this.reaction.scale.x));
		this.reaction.x = Math.round((size.width - reaction.width) / 2);
		this.former.resize(size);
	}
	
	public function start(reaction:String):Void
	{
		this.target1.start();
		this.target2.start();
		this.reaction.texture = Asset.getTexture(reaction, true);
		this.resize(size);
		Tween.get(this.reaction.pivot).to( { y:0 }, 450, Ease.backOut);
	}
	
	public function formPair(items:Array<CType>):Void
	{
		this.former.formPairs(items, this.target1.type, this.target2.type);
	}
	
}