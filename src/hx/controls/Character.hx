package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Character extends Container
{
	private var sprite:Sprite;

	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.sprite = Asset.getImage("collector.png", true);
		this.sprite.anchor.x = this.sprite.anchor.y = 0.5;
		this.sprite.scale.x = this.sprite.scale.y = 0.3;
		
		Tween.get(sprite.scale,{loop:true}).to( { x:0.25, y:0.25 }, 500, Ease.quadInOut).to( { x:0.3, y:0.3 }, 500, Ease.quadInOut);
		this.addChild(this.sprite);
	}
	
}