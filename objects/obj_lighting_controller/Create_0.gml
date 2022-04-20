mainSurface = -1;
compSurface = -1;
ambientLight = 0.3;

//screen vars
screenWidth = 700;
screenHeight = 700;

//light positions for the shaders
u_pos = shader_get_uniform(shd_light, "u_pos");
u_pos2 = shader_get_uniform(shd_shadow, "u_pos");

//directional light vars
u_dir = shader_get_uniform(shd_light, "u_dir");
u_fov = shader_get_uniform(shd_light, "u_fov");
u_radius = shader_get_uniform(shd_light, "u_radius");

//creating vertex format
vertex_format_begin();
vertex_format_add_position_3d();
vf = vertex_format_end();

//create vertex buffer
vb = vertex_create_buffer();

//blurring shader vars
u_texel_size = shader_get_uniform(shd_blur, "texel_size"); 
u_blur_vector = shader_get_uniform(shd_blur, "blur_vector"); //direction of blur

texel_w = 1 / screenWidth;
texel_h = 1 / screenHeight;

srf_ping = -1;
