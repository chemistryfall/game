package matter;
import matter.Matter.IBodyDefinition;
import matter.Matter.IBodyRenderOptions;

@:native("Matter.Body")
extern class Body {
	static function applyForce(body:Body, position:Vector, force:Vector):Void;
	static function applyGravityAll(bodies:Array<Body>, gravity:Vector):Void;
	static function create(options:IBodyDefinition):Body;
	static function nextGroup(?isNonColliding:Bool):Int;
	static function nextCategory():Int;
	static function resetForcesAll(bodies:Array<Body>):Void;
	static function rotate(body:Body, angle:Float):Void;
	static function setPosition(body:Body, position:Vector):Void;
	static function setVelocity(body:Body, velocity:Vector):Void;
	static function setAngularVelocity(body:Body, velocity:Float):Void;
	static function setAngle(body:Body, angle:Float):Void;
	static function setDensity(body:Body, density:Float):Void;
	static function setStatic(body:Body, isStatic:Bool):Void;
	static function setParts(body:Body, parts:Array<Body>):Void;
	static function set(body:Body, settings:IBodyDefinition):Void;
	static function scale(body:Body, scaleX:Float, scaleY:Float, ?poinst:Vector):Void;
	static function translate(body:Body, translation:Vector):Void;
	static function update(body:Body, deltaTime:Float, timeScale:Float, correction:Float):Void;
	static function updateAll(bodies:Array<Body>, deltaTime:Float, timeScale:Float, correction:Float, worldBounds:Bounds):Void;
	var angle : Float;
	var angularSpeed : Float;
	var angularVelocity : Float;
	var area : Float;
	var axes : Array<Vector>;
	var bounds : Bounds;
	var chamfer : Float;
	var density : Float;
	var force : Vector;
	var friction : Float;
	var frictionAir : Float;
	var groupId : Float;
	var id : Float;
	var inertia : Float;
	var inverseInertia : Float;
	var inverseMass : Float;
	var isSleeping : Bool;
	var isStatic : Bool;
	var isSensor : Bool;
	var label : String;
	var mass : Float;
	var motion : Float;
	var plugin : Dynamic;
	var position : Vector;
	var render : IBodyRenderOptions;
	var restitution : Float;
	var sleepThreshold : Float;
	var slop : Float;
	var speed : Float;
	var timeScale : Float;
	var torque : Float;
	var type : String;
	var velocity : Vector;
	var vertices : Array<Vector>;
	var parts : Array<Body>;
	var parent : Body;
	var collisionFilter : Dynamic;
}
