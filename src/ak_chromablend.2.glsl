uniform float adsk_result_w;
uniform float adsk_result_h;
uniform sampler2D adsk_results_pass1;

uniform float edge_blur;
uniform float edge_gain;

vec2 res   = vec2(adsk_result_w,adsk_result_h);
vec2 uv    = gl_FragCoord.xy / res.xy;

float blur_value = edge_blur;

void main(void) {
  int blur_value_int = int(blur_value);

  vec3 col = vec3(0.0);
  float energy = 0.0;

  for(int x = -blur_value_int; x <= blur_value_int; x++) {
    vec2 current = vec2(uv.x+float(x)/res.x,uv.y);
    vec3 sample  = texture2D(adsk_results_pass1,current).rgb;

    float pass = 1.0 - (abs(float(x)) / blur_value);
    energy += pass;
    col += sample * pass;
  }

  if(energy > 0.0) {
    gl_FragColor = vec4(clamp(col/energy*edge_gain,0.0,1.0),1.0);
  } else {
    gl_FragColor = vec4(texture2D(adsk_results_pass1,uv));
  }
}

