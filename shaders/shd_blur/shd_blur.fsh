//-------------------------------------------------------------------
// BLUR Fragment Shader:
// 2-PASS with LINEAR INTERPOLATED samples (aka Fast Blur)
//-------------------------------------------------------------------
// - Vertex Shader is a pass-though shader
// - blur_vector:  (1.0, 0.0) for horizontal blur
//                 (0.0, 1.0) for vertical blur
// - texel_size:   (image uv width) / (image pixel width)
//                 where image uv width is 1 if image is on a
//                 seperate texture page or is a surface
// - steps:        only even step sizes allowed, odd step sizes
//                 would need a different algorithm and are
//                 less efficient
// - clamp:        add clamp() if image is a sprite not on its own
//                 texture page:
//                 clamp(v_vTexcoord [...] * blur_vector, 0, 1)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 blur_vector;
uniform vec2 texel_size;

void main()
{
   highp vec4 blurred_col;
   vec2 offset_factor = texel_size * blur_vector;

   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 15.4651754 * offset_factor) * 0.0291248;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 13.4696570 * offset_factor) * 0.0377901;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 11.4741435 * offset_factor) * 0.0473034;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 9.4786343 * offset_factor) * 0.0571220;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 7.4831284 * offset_factor) * 0.0665446;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 5.4876254 * offset_factor) * 0.0747859;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 3.4921243 * offset_factor) * 0.0810821;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord - 1.4966245 * offset_factor) * 0.0848062;

   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord) * 0.0428819;

   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 1.4966245 * offset_factor) * 0.0848062;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 3.4921243 * offset_factor) * 0.0810821;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 5.4876254 * offset_factor) * 0.0747859;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 7.4831284 * offset_factor) * 0.0665446;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 9.4786343 * offset_factor) * 0.0571220;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 11.4741435 * offset_factor) * 0.0473034;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 13.4696570 * offset_factor) * 0.0377901;
   blurred_col += texture2D(gm_BaseTexture, v_vTexcoord + 15.4651754 * offset_factor) * 0.0291248;

   gl_FragColor = v_vColour * blurred_col;
}
