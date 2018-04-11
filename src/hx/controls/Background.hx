package controls;

import filters.bg.BgFilter;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.extras.TilingSprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Background extends Container
{
	public var charpos:Float = 0;
	
	private var filter: BgFilter;

	private var bg:TilingSprite;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.bg = new TilingSprite( Asset.getTexture("bg.jpg", false), 2048,2048);
		
		
		this.filter = new BgFilter();
		this.filterArea =untyped Main.instance.renderer.screen;
		//this.filters = [filter];
		
		this.addChild(this.bg);
		
		Main.instance.tickListeners.push(onTick);
	}
	
	private function onTick(delta:Float):Void
	{
		this.bg.tilePosition.y -= delta * 3;
		this.bg.tilePosition.x = charpos;
	}
	
	public function resize(size:Rectangle):Void
	{
		
		this.filter.resize(size);
	}
}