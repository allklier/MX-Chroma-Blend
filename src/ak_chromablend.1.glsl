 
uniform float adsk_result_w;
uniform float adsk_result_h;
uniform sampler2D Matte;

vec2 res   = vec2(adsk_result_w,adsk_result_h);
vec2 uv    = gl_FragCoord.xy / res.xy;

// Code derived from: gist.github.com/Hebali/6ebfc66106459aacee6a9fac029d0115

void main(void) {
  vec4 k[9];

  float w = 1.0 / res.x;
  float h = 1.0 / res.y;

  k[0] = texture2D(Matte,uv + vec2( -w, -h));
  k[1] = texture2D(Matte,uv + vec2(0.0, -h));
  k[2] = texture2D(Matte,uv + vec2(  w, -h));
  k[3] = texture2D(Matte,uv + vec2( -w,0.0));
  k[4] = texture2D(Matte,uv);
  k[5] = texture2D(Matte,uv + vec2(  w,0.0));
  k[6] = texture2D(Matte,uv + vec2( -w,  h));
  k[7] = texture2D(Matte,uv + vec2(0.0,  h));
  k[8] = texture2D(Matte,uv + vec2(  w,  h));

  vec4 sobel_edge_h = k[2] + (2.0*k[5]) + k[8] - (k[0] + (2.0*k[3]) + k[6]);
  vec4 sobel_edge_v = k[0] + (2.0*k[1]) + k[2] - (k[6] + (2.0*k[7]) + k[8]);
  vec4 sobel        = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));

  gl_FragColor = vec4(sobel.rgb,1.0);
}

