package controls;

import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import util.Asset;
import controls.Compound.CompoundType;
import util.MathUtil;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Jar extends Container
{
	private var jar:Sprite;
	
	private var alu_bromide:Compound;
	private var alu_oxide:Compound;
	private var lithium_bromide:Compound;
	private var lithium_oxide:Compound;
	private var mag_bromide:Compound;
	private var mag_oxide:Compound;
	
	private static var textures:Array<String>=[];
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.jar = Asset.getImage("jar_1.png", true);
		this.jar.anchor.x = 0.5;
		this.jar.anchor.y = 1;
		this.jar.scale.x = this.jar.scale.y = 0.6;
		this.addChild(this.jar);
		
		alu_bromide = createcompound(CompoundType.alu_bromide);
		alu_oxide = createcompound(CompoundType.alu_oxide);
		lithium_bromide = createcompound(CompoundType.lithium_bromide);
		lithium_oxide = createcompound(CompoundType.lithium_oxide);
		mag_bromide = createcompound(CompoundType.mag_bromide);
		mag_oxide = createcompound(CompoundType.mag_oxide);
		
	}
	
	private function createcompound(type:CompoundType):Compound
	{
		var c:Compound = new Compound(type);
		c.pivot.y = c.height;
		c.scale.x = c.scale.y = 1;
		c.y = -180;
		this.jar.addChild(c);
		return c;
	}
	
	public function resize(size:Rectangle):Void
	{
		this.jar.scale.x = this.jar.scale.y  = 1;
		var sw:Float = size.width / Main.instance.viewport.scale.x*0.9;
		var sh:Float = size.height / Main.instance.viewport.scale.x*0.9;
		var s:Float = Math.min(1, Math.min( sw / jar.width, sh / jar.height));
		this.jar.scale.x = this.jar.scale.y = s;
	}
	
	
	public function randomize():Void
	{
		if (textures.length == 0)
		{
			textures = [
				"1","2","3","4","5","6"
			];
			textures = MathUtil.shuffle(textures,cast Date.now().getTime());
		}
		
		this.jar.texture = Asset.getTexture("jar_" +textures.pop() + ".png", true);
		
		alu_bromide.visible = GameView.CONF.compound == CompoundType.alu_bromide;
		alu_oxide.visible = GameView.CONF.compound == CompoundType.alu_oxide;
		lithium_bromide.visible = GameView.CONF.compound == CompoundType.lithium_bromide;
		lithium_oxide.visible = GameView.CONF.compound == CompoundType.lithium_oxide;
		mag_bromide.visible = GameView.CONF.compound == CompoundType.mag_bromide;
		mag_oxide.visible = GameView.CONF.compound == CompoundType.mag_oxide;
		
		
	}
	
	
	
}