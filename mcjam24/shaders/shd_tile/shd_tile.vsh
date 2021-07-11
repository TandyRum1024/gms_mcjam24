//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 uUVs;

void main()
{
    vec4 pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
	pos = gm_Matrices[MATRIX_WORLD] * pos;
	vec4 posView = gm_Matrices[MATRIX_VIEW] * pos;
    gl_Position = gm_Matrices[MATRIX_PROJECTION] * posView;
    
	const vec3 sunDir = vec3(0.5, 0.1, -1.0);
	float light = -dot(in_Normal, normalize(sunDir)) * 0.5 + 0.5;
	vec4 col = in_Colour;
	col.rgb *= mix(0.8, 1.0, light);
	
    v_vColour = col;
    v_vTexcoord = uUVs.xy + uUVs.zw * in_TextureCoord;
}
