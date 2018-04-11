package filters.bg;

import haxe.Resource;
import js.Lib;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.renderers.webgl.filters.Filter;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.extras.TilingSprite;
import util.Asset;

/**
 * ...
 * @author 
 */
class BgFilter extends Filter
{
	public var uniforms:Dynamic;
	
	private var time:Float = 0;
	
	public function new() 
	{
		var frag:String = Resource.getString("bg.frag");
		super(null, frag, uniforms);
		untyped this.padding = 0;
	}
	
	public function resize(size:Rectangle):Void
	{
		this.uniforms.aspect = size.height / size.width;
	}
	
	override public function apply(filterManager:Dynamic, input:Dynamic, output:Dynamic, ?clear:Bool):Void 
	{
		time+= 1 / 60;
		this.uniforms.time = time;
		super.apply(filterManager, input, output, clear);
	}
}