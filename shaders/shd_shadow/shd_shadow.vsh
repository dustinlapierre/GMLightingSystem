attribute vec3 in_Position;                  // (x,y,z)

uniform vec2 u_pos;

void main()
{
	vec2 pos = in_Position.xy;
	if(in_Position.z > 0.0)
	{
		vec2 dis = pos - u_pos;
		//if z is set, offset the far edge of the shadow by the distance to the light source * infinity
		//pos += dis * 100000.0;
		//essentially the same as above but normalized between -1 and 1 ex. (x: 1.00, y: -0.10) (UNIT VECTOR)
		pos += dis/length(dis) * 100000.0;
	}
    vec4 object_space_pos = vec4( pos.x, pos.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
