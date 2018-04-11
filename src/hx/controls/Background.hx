package controls;

import filters.bg.BgFilter;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Background extends Container
{
	private var filter: BgFilter;

	private var bg:Sprite;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.bg = Asset.getImage("bg.jpg", false);
		
		
		this.filter = new BgFilter();
		this.filterArea =untyped Main.instance.renderer.screen;
	//	this.filters = [filter];
		
		this.addChild(this.bg);
	}
	
	public function resize(size:Rectangle):Void
	{
		
		this.filter.resize(size);
	}
}