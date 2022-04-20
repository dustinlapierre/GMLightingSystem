varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 pos;
uniform vec2 u_pos; //position of the light source
uniform float u_fov;
uniform float u_dir;
uniform float u_radius;

#define PI 3.1415926538

void main()
{
	// Work out vector from room location to the light
    vec2 vect = pos - u_pos;
	// Length of that vector
	float dist = sqrt(vect.x * vect.x + vect.y * vect.y);
	
	//falloff light over distance
	float falloff = dist/u_radius;
	
	//strength of the light
	float str = 1./(sqrt(vect.x*vect.x + vect.y*vect.y + u_radius*u_radius)-u_radius) * 50.;
	
	float dir = radians(u_dir);
	float hfov = radians(u_fov)*0.5;
	
	if(hfov < PI)
	{
		float rad = atan(-vect.y, vect.x);
		float adis = abs(mod(rad+2.0*PI, 2.0*PI) - dir);
		adis = min(adis, 2.0*PI - adis);
		
		str *= clamp((1. - adis/hfov)*3.,0.0,1.0);	
	}
	
	vec4 base_col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	if(u_fov == 360.0)
	{
		//harder edge on radial light
		gl_FragColor = mix(base_col, vec4(0.0,0.0,0.0,1.0), falloff);
	}
	else
	{
		//soft style on directional lights
		gl_FragColor = base_col * vec4(vec3(str),1.0);
	}
}
