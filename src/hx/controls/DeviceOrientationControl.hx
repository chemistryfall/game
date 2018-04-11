package controls;
import js.Browser;
import js.html.DeviceOrientationEvent;
import js.three.Camera;
import js.three.Euler;
import js.three.PerspectiveCamera;
import js.three.Quaternion;
import js.three.Vector3;

/**
 * Device orientation controls. Based on https://github.com/mrdoob/three.js/blob/master/examples/js/controls/DeviceOrientationControls.js
 * Threejs is used to get quaternions and calculate orientation from camera eulers.
 * @author 
 */
class DeviceOrientationControl
{
	public static var lon:Float = 0;
	public static var lat:Float = 0;
	public static var absolute:Bool = true;
	public static var beta:Float = 0;
	public static var alpha:Float = 0;
	public static var gamma:Float = 0;
	
	private static var camera:Camera;
	
	private static var deviceOrientation:Dynamic = {};
	private static var screenOrientation:Int = 0;
	private static var alphaOffset:Float=0;
	
	public function new() 
	{
		
	}
	
	public static function initialize():Void
	{
		camera = new PerspectiveCamera();
		DeviceOrientationControl.camera = camera;
		camera.rotation.reorder("YXZ");
		Browser.window.addEventListener("deviceorientation", handleDeviceOrientation);
		Browser.window.addEventListener("orientationchange", handleScreenOrientation);
		trace("Orientation controller started");
		handleScreenOrientation(null); // run once on load
		
	}
	
	private static function handleScreenOrientation(e:Dynamic):Void
	{
		if (Browser.window.orientation == null)
			DeviceOrientationControl.screenOrientation = 0;
		else
			DeviceOrientationControl.screenOrientation = Browser.window.orientation;
	}
	
	private static function handleDeviceOrientation(e:DeviceOrientationEvent):Void
	{
		trace("HAndle orientation");
		absolute = e.absolute;
		if (true || e.absolute)
		{
			beta = e.beta;
			alpha = e.alpha;
			gamma = e.gamma;
			
			var alpha =js.three.Math.degToRad(alpha); // Z
			var beta = js.three.Math.degToRad(beta); // X'
			var gamma = js.three.Math.degToRad(gamma); // Y''
			var orient = js.three.Math.degToRad(0); // O
			
			var currentQ:Quaternion = camera.quaternion;
			
			
			
			setObjectQuaternion()(currentQ, alpha, beta, gamma, orient);
			var rotation:Euler =new Euler().setFromQuaternion( currentQ, "YXZ" );
			Main.instance.updateRotation( rotation.z);
		}
	}
	
	// The angles alpha, beta and gamma form a set of intrinsic Tait-Bryan angles of type Z-X'-Y''
	private static function setObjectQuaternion()
	{
		var zee = new Vector3( 0, 0, 1 );
		var euler = new Euler();
		var q0 = new Quaternion();
		var q1 = new Quaternion(  - Math.sqrt( 0.5 ), 0, 0,  Math.sqrt( 0.5 ) ); // - PI/2 around the x-axis
		
		//beta=beta-180;
		return function ( quaternion:Quaternion, alpha:Float, beta:Float, gamma:Float, orient:Float ) {
			euler.set( beta, alpha, - gamma, 'YXZ' );                       // 'ZXY' for the device, but 'YXZ' for us
			quaternion.setFromEuler( euler );                               // orient the device
			quaternion.multiply( q1 );                                      // camera looks out the back of the device, not the top
			quaternion.multiply( q0.setFromAxisAngle( zee, - orient ) );    // adjust for screen orientation
		}
	}

	private static function Quat2Angle( x:Float, y:Float, z:Float, w:Float ):Vector3
	{
		var pitch:Float;
		var roll:Float;
		var yaw:Float;

		var test:Float = x * y + z * w;
		if (test > 0.499) 
		{ // singularity at north pole
			yaw = 2 * Math.atan2(x, w);
			pitch = Math.PI / 2;
			roll = 0;

			var euler = new Vector3( pitch, roll, yaw);
			return euler;
		}
		if (test < -0.499) 
		{ // singularity at south pole
			yaw = -2 * Math.atan2(x, w);
			pitch = -Math.PI / 2;
			roll = 0;
			var euler = new Vector3( pitch, roll, yaw);
			return euler;
		}
		var sqx:Float = x * x;
		var sqy:Float = y * y;
		var sqz:Float = z * z;
		yaw = Math.atan2(2 * y * w - 2 * x * z, 1 - 2 * sqy - 2 * sqz);
		pitch = Math.asin(2 * test);
		roll = Math.atan2(2 * x * w - 2 * y * z, 1 - 2 * sqx - 2 * sqz);

		var euler = new Vector3( pitch, roll, yaw);
		return euler;
}

	
}