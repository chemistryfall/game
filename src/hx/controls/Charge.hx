package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
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
class Charge extends Container
{
	public var count:Text;
	private var beaker:Sprite;
	private var charge:Sprite;
	private var slider:Sprite;
	
	private var amount:Int = 0;
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.beaker = Asset.getImage("corner beaker.png", true);
		this.beaker.scale.x =  this.beaker.scale.y = 0.4;
		this.beaker.anchor.x = 0.0;
		
		var ts:TextStyleObject = { };
		ts.fontSize = 70;
		this.count = new Text("5", ts);
		this.count.x = 60;
		this.count.y = 50;
		this.beaker.addChild(this.count);
		
		this.charge = Asset.getImage("charge_slider.png", true);
		this.slider = Asset.getImage("charge_sliderPointer.png", true);
		
		this.slider.anchor.x = 0.5;
		this.charge.anchor.x = 0.5;
		
		this.charge.scale.x = this.charge.scale.y = 0.7;
		this.charge.addChild(this.slider);
		
		this.addChild(this.beaker);
		
		this.addChild(this.charge);
		
		this.charge.pivot.y = 100;
		this.beaker.pivot.x = 200;
	}
	
	public function updateCharge(amount:Int):Void
	{
		if (Math.abs(amount) > 5 && Math.abs(this.amount)==5 )
		{
			amount = cast Math.min(5, Math.max( -5, amount));
			Tween.get(this.slider).to( { x: amount * 28 }, 350, Ease.backInOut).to({x:amount*27},350, Ease.backInOut);
		}
		else
		{
			amount = cast Math.min(5, Math.max( -5, amount));
			Tween.get(this.slider).to( { x: amount * 27 }, 350, Ease.backInOut);
			this.amount = amount;
		}
	}
	
	public function show():Void
	{
		this.amount = 0;
		Tween.get(this.charge.pivot).to( { y:-90 }, 450, Ease.getBackOut(0.3));
		Tween.get(this.beaker.pivot).to( { x:0 }, 450, Ease.getBackOut(0.3));
	}
	
	public function hide():Void 
	{
		Tween.get(this.charge.pivot).to( { y:100 }, 450, Ease.backIn);
		Tween.get(this.beaker.pivot).to( { x:200 }, 450, Ease.backIn);
	}
	
	public function resize(size:Rectangle):Void
	{
		this.charge.x = size.width / 2;
		this.beaker.y = size.height - beaker.height;
		this.beaker.x = 0;
	}
}
