package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import pixi.core.text.Text;
import controls.Collectable.CType;
import pixi.core.text.TextStyleObject;

/**
 * ...
 * @author Henri Sarasvirta
 */
class TargetIndicator extends Container
{
	public var type:CType;
	
	private var cOxygen:Collectable;
	private var cLithium:Collectable;
	private var cAluminium:Collectable;
	private var cBrohm:Collectable;
	private var cMagnesium:Collectable;
	
	private var ac:Collectable;
	public var count:Text;
	private var left:Bool = false;
	
	public function new(left:Bool) 
	{
		super();
		this.left = left;
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.cOxygen = new Collectable(CType.oxygen);
		this.cLithium = new Collectable(CType.lithium);
		this.cAluminium = new Collectable(CType.aluminium);
		this.cBrohm = new Collectable(CType.brohm);
		this.cMagnesium = new Collectable(CType.magnesium);
		
		this.addChild(cOxygen);
		this.addChild(cLithium);
		this.addChild(cBrohm);
		this.addChild(cMagnesium);
		this.addChild(cAluminium);
		
		this.cOxygen.scale.x = this.cOxygen.scale.y = 0.25;
		this.cLithium.scale.x = this.cLithium.scale.y = 0.25;
		this.cBrohm.scale.x = this.cBrohm.scale.y = 0.25;
		this.cMagnesium.scale.x = this.cMagnesium.scale.y = 0.25;
		this.cAluminium.scale.x = this.cAluminium.scale.y = 0.25;
		
		this.cOxygen.x = 50;
		this.cOxygen.y = 50;
		this.cLithium.x = 50;
		this.cLithium.y = 50;
		this.cBrohm.x = 50;
		this.cBrohm.y = 50;
		this.cMagnesium.x = 50;
		this.cMagnesium.y = 50;
		this.cAluminium.x = 50;
		this.cAluminium.y = 50;
		
		var ts:TextStyleObject = { };
		ts.fontFamily = 'pigment_demoregular';
		this.count = new Text("7", ts);
		this.addChild(this.count);
		
		this.pivot.y = -50;
		
		this.pivot.x = left ? 100 : -100;
		
		this.count.alpha = 0;
	}
	
	public function setType(type:CType):Void
	{
		this.type = type;
		this.cOxygen.visible = type == CType.oxygen;
		this.cLithium.visible = type == CType.lithium;
		this.cBrohm.visible = type == CType.brohm;
		this.cMagnesium.visible = type == CType.magnesium;
		this.cAluminium.visible = type == CType.aluminium;
	}
	
	public function setcount(val:Int):Void
	{
		this.count.text = Std.string(val);
	}
	
	public function start():Void
	{
		Tween.get(this.pivot).wait(450, true).to( { x:0 }, 450, Ease.getBackOut(1.3));
		Tween.get(this.count).wait(900, true).to( { alpha:1 }, 450);
	}
	public function hide():Void
	{
		Tween.get(this.pivot).to( { x:left?100:-100 }, 450, Ease.backIn);
		Tween.get(this.count).to( { alpha:0 }, 450);
	}
}