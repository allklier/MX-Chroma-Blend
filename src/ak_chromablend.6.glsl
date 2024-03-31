uniform float adsk_result_w;
uniform float adsk_result_h;
uniform sampler2D adsk_results_pass3;
uniform sampler2D Front;

uniform float blur_fg;
uniform bool use_edge;

vec3 adsk_rgb2yuv(in vec3 color);
vec3 adsk_yuv2rgb(in vec3 color);

vec2 res   = vec2(adsk_result_w,adsk_result_h);
vec2 uv    = gl_FragCoord.xy / res.xy;

float blur_value = blur_fg;

void main(void) {
  int blur_value_int = int(use_edge? blur_value * texture2D(adsk_results_pass3,uv).r : blur_value);

  vec3 col = vec3(0.0);
  float energy = 0.0;

  for(int x = -blur_value_int; x <= blur_value_int; x++) {
    vec2 current = vec2(uv.x+float(x)/res.x,uv.y);
    vec3 sample  = adsk_rgb2yuv(texture2D(Front,current).rgb);

    float pass = 1.0 - (abs(float(x)) / blur_value);
    energy += pass;
    col += sample * pass;
  }

  if(energy > 0.0) {
    gl_FragColor = vec4(adsk_rgb2yuv(texture2D(Front,uv).rgb).r,(col/energy).g,(col/energy).b,1.0);
  } else {
    gl_FragColor = vec4(adsk_rgb2yuv(texture2D(Front,uv).rgb),1.0);
  }
}

