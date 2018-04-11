package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import matter.Bodies;
import matter.Body;
import matter.World;
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

	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.sprite = Asset.getImage("collector.png", true);
		this.sprite.anchor.x = this.sprite.anchor.y = 0.5;
		this.sprite.scale.x = this.sprite.scale.y = 0.2;
		
		this.body = Bodies.circle(0, 0, sprite.width / 2, { friction: 0.00001, restitution: 0.5, density: 0.001 } );
		World.add(Main.instance.world, this.body);
		
		//Tween.get(sprite.scale,{loop:true}).to( { x:0.25, y:0.25 }, 500, Ease.quadInOut).to( { x:0.3, y:0.3 }, 500, Ease.quadInOut);
		this.addChild(this.sprite);
	}
	
}