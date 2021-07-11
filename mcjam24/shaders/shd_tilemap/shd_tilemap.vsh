//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
	pos = gm_Matrices[MATRIX_WORLD] * pos;
	vec4 posView = gm_Matrices[MATRIX_VIEW] * pos;
    gl_Position = gm_Matrices[MATRIX_PROJECTION] * posView;
    
	const vec3 sunDir = vec3(0.5, 0.1, -1.0);
	float light = -dot(in_Normal, normalize(sunDir)) * 0.5 + 0.5;
	vec4 col = in_Colour;
	col.rgb *= light;
	
	// Height tint
	const float max_height = 20.0 * 32.0;
	float height = mix(0.8, 1.1, smoothstep(0.0, max_height, pos.z));
	col.rgb *= height;
	
	// Light
	float dist = length(posView.xyz);
	col.rgb += mix(vec3(0.0), vec3(0.3, 0.25, 0.1), smoothstep(50.0, 0.0, dist));
	
    v_vColour = col;
    v_vTexcoord = in_TextureCoord;
}
