package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import matter.Bodies;
import matter.Body;
import matter.World;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Character extends Container
{
	public var body:Body;
	private var sprite:Sprite;
	private var arrow:Sprite;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.sprite = Asset.getImage("collector/collector_1.png", true);
		this.sprite.anchor.x = 0.5;
		this.sprite.anchor.y = 270/300/2;
		this.sprite.scale.x = this.sprite.scale.y = 0.7;
		var sprite2:Sprite = Asset.getImage("collector/collector_2.png", true);
		sprite2.anchor.x = 0.5;
		sprite2.anchor.y = sprite.anchor.y;
		sprite2.scale.x = sprite2.scale.y = 0.7;
		var sprite3:Sprite = Asset.getImage("collector/collector_3.png", true);
		sprite3.anchor.x = 0.5;
		sprite3.anchor.y = sprite.anchor.y;
		sprite3.scale.x = sprite3.scale.y = 0.7;
		var sprite4:Sprite = Asset.getImage("collector/collector_4.png", true);
		sprite4.anchor.x = 0.5;
		sprite4.anchor.y = sprite.anchor.y;
		sprite4.scale.x = sprite4.scale.y = 0.7;
		
		sprite.blendMode = Pixi.BLEND_MODES.ADD;
		sprite2.blendMode = Pixi.BLEND_MODES.ADD;
		sprite3.blendMode = Pixi.BLEND_MODES.ADD;
		sprite4.blendMode = Pixi.BLEND_MODES.ADD;
		
		sprite.alpha = sprite2.alpha = sprite3.alpha = sprite4.alpha = 0.1;
	
		Tween.get(sprite, { loop:true } ).to( { rotation:Math.PI * 2 }, 18000);
		Tween.get(sprite2, { loop:true } ).to( { rotation:Math.PI * 2 }, 18300);
		Tween.get(sprite3, { loop:true } ).to( { rotation:-Math.PI * 2 }, 18200);
		Tween.get(sprite4, { loop:true } ).to( { rotation:-Math.PI * 2 }, 18100);
		
		this.addChild(sprite2);
		this.addChild(sprite2);
		this.addChild(sprite3);
		
		this.arrow = Asset.getImage("collector/collector_arrow.png", true);
		this.arrow.scale = this.sprite.scale;
		this.arrow.anchor = this.sprite.anchor;
		this.addChild(this.arrow);
		
		this.body = Bodies.circle(0, 0, sprite.width / 2*0.8, { friction: 0.00001, restitution: 0.5, density: 0.001 } );
		World.add(Main.instance.world, this.body);
		
		//Tween.get(sprite.scale,{loop:true}).to( { x:0.25, y:0.25 }, 500, Ease.quadInOut).to( { x:0.3, y:0.3 }, 500, Ease.quadInOut);
		this.addChild(this.sprite);
		
		Main.instance.tickListeners.push(ontick);
	}
	
	private function ontick(d:Float):Void
	{
		/*
		this.sprite.rotation += (Math.random()-0.5)/6;
		this.sprite.rotation += (Math.random()-0.5)/6;
		this.sprite.rotation += (Math.random()-0.5)/6;
		this.sprite.rotation += (Math.random()-0.5)/6;
		*/
	}
	
}