 
uniform float adsk_result_w;
uniform float adsk_result_h;
uniform sampler2D Front;
uniform sampler2D Back;
uniform sampler2D Matte;
uniform sampler2D adsk_results_pass3;
uniform sampler2D adsk_results_pass5;
uniform sampler2D adsk_results_pass7;

uniform float mix_bg;
uniform bool  use_edge;
uniform bool  show_mask;
uniform int   y_source;

vec3 adsk_rgb2yuv(in vec3 color);
vec3 adsk_yuv2rgb(in vec3 color);

vec2 res   = vec2(adsk_result_w,adsk_result_h);
vec2 uv    = gl_FragCoord.xy / res.xy;

void main(void) {
  vec3 chroma_bg_yuv = texture2D(adsk_results_pass5,uv).rgb;
  vec3 chroma_fg_yuv = texture2D(adsk_results_pass7,uv).rgb;
  float original_y   = (y_source == 1)? adsk_rgb2yuv(texture2D(Back,uv).rgb).r : adsk_rgb2yuv(texture2D(Front,uv).rgb).r;
  float mix_value    = use_edge? mix_bg * texture2D(adsk_results_pass3,uv).r : mix_bg;

  vec4 pixel_rgb = vec4(adsk_yuv2rgb(vec3(original_y,mix(chroma_fg_yuv,chroma_bg_yuv,mix_value).gb)),1.0);

  if(show_mask) {
    gl_FragColor = vec4(texture2D(adsk_results_pass3,uv).r);
  } else {
    gl_FragColor = mix(texture2D(Back,uv),pixel_rgb,texture2D(Matte,uv).r);
  }
}

