package controls;

import filters.bg.BgFilter;
import pixi.core.display.Container;
import pixi.core.math.Point;
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
	
	public var filter: BgFilter;

	private var bg:TilingSprite;
	private var offx:Float = 0;
	private var offy:Float = 0;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.bg = new TilingSprite( Asset.getTexture("bg.jpg", false), 2048,2048);
		this.bg.tileScale.x = this.bg.tileScale.y = 0.5;
		
		this.filter = new BgFilter();
		this.filterArea =untyped Main.instance.renderer.screen;
	//	this.filters = [filter];
		
		this.addChild(this.bg);
		
	}
	
	public function rememberPosition(charpos:Point):Void
	{
		offx += -charpos.x;
		offy += -charpos.y;
	}
	public function update(charX:Float, charY:Float):Void
	{
		this.bg.tilePosition.x = (charX+offx)%2048;
		this.bg.tilePosition.y = (charY+offy)%2048;
	}
	
	
	public function resize(size:Rectangle):Void
	{
		
		this.filter.resize(size);
	}
}