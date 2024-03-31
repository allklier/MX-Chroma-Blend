uniform float adsk_result_w;
uniform float adsk_result_h;
uniform sampler2D Back;
uniform sampler2D adsk_results_pass3;
uniform sampler2D adsk_results_pass4;

uniform float blur_bg;
uniform bool use_edge;

vec3 adsk_rgb2yuv(in vec3 color);
vec3 adsk_yuv2rgb(in vec3 color);

vec2 res   = vec2(adsk_result_w,adsk_result_h);
vec2 uv    = gl_FragCoord.xy / res.xy;

float blur_value = blur_bg;

void main(void) {
  int blur_value_int = int(use_edge? blur_value * texture2D(adsk_results_pass3,uv).r : blur_value);

  vec3 col = vec3(0.0);
  float energy = 0.0;

  for(int y = -blur_value_int; y <= blur_value_int; y++) {
    vec2 current = vec2(uv.x,uv.y+float(y)/res.y);
    vec3 sample  = texture2D(adsk_results_pass4,current).rgb;

    float pass = 1.0 - (abs(float(y)) / blur_value);
    energy += pass;
    col += sample * pass;
  }

  if(energy > 0.0) {
    gl_FragColor = vec4(texture2D(adsk_results_pass4,uv).r,(col/energy).g,(col/energy).b,1.0);
  } else {
    gl_FragColor = vec4(texture2D(adsk_results_pass4,uv).rgb,1.0);
  }
}

