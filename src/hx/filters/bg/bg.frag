precision mediump float;

varying mediump vec2 vTextureCoord;

uniform sampler2D uSampler;

uniform float time;
uniform vec4 filterClamp;

uniform float aspect;

float sind(vec2 p, float ph, float rad, float off, float tmp)
{
 	return smoothstep(0.,8.,1./abs(p.y*ph-sin(off+p.x+time*tmp*0.24)*rad))*8.;
}

void main(  )
{
	// Normalized pixel coordinates (from 0 to 1)
    vec2 uv = vTextureCoord-vec2(0.,0.5);
	uv.y*=aspect;
    // Time varying pixel color
    vec3 col =vec3(.0);// 0.5 + 0.5*cos(time+uv.xyx+vec3(0,2,4));

    vec3 b = 0.5 + 0.5*cos(time+uv.xyx+vec3(0,2,4));
    
    col+=sind(uv, 20., 5.,0.0,0.2)*b;
    col+=sind(uv, 40., 10.,1.0,0.4)*b;
    col+=sind(uv, 60., 20.,2.0,0.6)*b;
    col+=sind(uv, 80., 30.,3.0,0.8)*b;
    col+=sind(uv, 100., 40.,4.0,1.0)*b;
    
    // Output to screen
    gl_FragColor = vec4(col,1.0)*0.25;
//	gl_FragColor = vec4(1.,1.,1.,1.);
	//gl_FragColor = vec4(uv.x, uv.y,0.,1.);
}
