var _u_pos = u_pos;
var _u_pos2 = u_pos2;
var _u_dir = u_dir;
var _u_fov = u_fov;
var _u_radius = u_radius;
var _vb = vb;

if(!surface_exists(mainSurface)) mainSurface = surface_create(screenWidth, screenHeight);
if(!surface_exists(compSurface)) compSurface = surface_create(screenWidth, screenHeight);

//pass into with statements
var _mainSurface = mainSurface;
var _compSurface = compSurface;

//Clear the main surface
surface_set_target(mainSurface);
draw_clear(c_black); //change shadow color here
surface_reset_target();

//for every light source
with(obj_light)
{
	
	surface_set_target(_compSurface);
		//fill with white
		draw_clear_alpha(c_white,1.0);
		//use shader and pos to draw shadow buffer
		shader_set(shd_shadow);
			shader_set_uniform_f(_u_pos2, x, y);
			vertex_submit(_vb, pr_trianglelist, -1);
		shader_reset();
	surface_reset_target();
	
	
	//draw light
	gpu_set_blendmode(bm_add);
		surface_set_target(_mainSurface);
			//draw light
			shader_set(shd_light);
			shader_set_uniform_f(_u_pos, x, y);
			shader_set_uniform_f(_u_dir, dir);
			shader_set_uniform_f(_u_fov, fov);
			shader_set_uniform_f(_u_radius, radius);
			//transfer shadows
			draw_surface_ext(_compSurface,0,0,1,1,0,image_blend,1);
			shader_reset();
		surface_reset_target();
	gpu_set_blendmode(bm_normal);
}

//fill in all blocks with shadow on mainSurface
surface_set_target(mainSurface);
shader_set(shd_silo);
with(obj_wall)
{
	draw_self();
}
with(obj_slope)
{
	draw_self();
}
shader_reset();
surface_reset_target();

//then blur or bloom entire shadow render (this adds edge lighting)
if(!surface_exists(srf_ping)) srf_ping = surface_create(screenWidth, screenHeight);
	
gpu_set_tex_filter(true); //must be set to get an accurate result
shader_set(shd_blur);
	shader_set_uniform_f(u_texel_size, texel_w, texel_h);
		
	//1st pass: horizontal
	shader_set_uniform_f(u_blur_vector, 1, 0);
	surface_set_target(srf_ping);
		draw_surface(mainSurface, 0, 0);
	surface_reset_target();
		
	//2nd pass vertical
	surface_set_target(mainSurface);
	shader_set_uniform_f(u_blur_vector, 0, 1);
	draw_surface(srf_ping, 0, 0);
	surface_reset_target();
shader_reset();
gpu_set_tex_filter(false);


//add ambient light back on to the surface
surface_set_target(mainSurface);
	draw_set_color(c_white);
	gpu_set_blendmode(bm_add);
	draw_set_alpha(ambientLight);
	draw_rectangle(0,0,screenWidth,screenHeight,false);
	draw_set_alpha(1.0);
surface_reset_target();
	
//Draw final surface with whatever blend mode you want.
gpu_set_blendmode_ext(bm_zero, bm_src_colour);
draw_surface(mainSurface,0,0);
gpu_set_blendmode(bm_normal);
