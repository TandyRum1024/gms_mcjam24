/*
	Mapgen heightmap shader
*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int uSeed;

// https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}
float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}
// classic Perlin 2D Noise by Stefan Gustavson
vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}
float cnoise(vec2 P){
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute(permute(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 * 
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}
// https://www.shadertoy.com/view/MdX3Rr
const mat2 m2 = mat2(0.8,-0.6,0.6,0.8);
float fbm( in vec2 p ){
    float f = 0.0;
    f += 0.5000*noise( p ); p = m2*p*2.02;
    f += 0.2500*noise( p ); p = m2*p*2.03;
    f += 0.1250*noise( p ); p = m2*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}

void main()
{
	// center-origin UVs: [-1, 1]
	vec2 uv = (v_vTexcoord - 0.5) * 2.0;
	float height;
	
	// Calculate island falloff
	float	distEdge = smoothstep(0.7, 1.0, max(abs(uv.x), abs(uv.y))),
			dist = smoothstep(length(vec2(0.5, 0.5))-0.05, 0.2, length(uv));
	//const vec2 heightMinimumFactor = vec2(0.0, 0.2);
	//const vec2 heightBiasFactor = vec2(0.1, 0.3);
	//float heightBias = mix(heightBiasFactor.y, heightBiasFactor.x, 1.0 - dist);
	//float heightMin = mix(heightMinimumFactor.y, heightMinimumFactor.x, 1.0 - dist);
	
	// Generate noise
	const float baseScale = 3.0,
				mountainScale = 3.0,
				mountainFactor = 0.1;
	vec2 seedPos = uv + fract(vec2(uSeed, -uSeed) * 0.001);
	float baseNoise = cnoise(seedPos * baseScale);
	float mountainNoise = fbm(seedPos * mountainScale);// * 2.0 - 1.0;
	height = mountainNoise; //clamp(baseNoise + mountainNoise*mountainFactor*dist, 0.0, 1.0);
	
	// Island reshaping thingamajig
	// https://www.redblobgames.com/maps/terrain-from-noise/#islands
	float d = length(uv) / sqrt(0.5);
	height = (1.0 + height - d) * 0.5;
	
	//height -= distEdge;
	//height = clamp(height, heightMin, 1.0);
	//height = clamp(heightBias * height, heightMin, 1.0);
	
    gl_FragColor = vec4(vec3(height), 1.0);
}
