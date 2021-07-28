shader_type canvas_item;

uniform sampler2D palette1;
uniform sampler2D palette2;
uniform sampler2D palette3;
uniform sampler2D palette4;
uniform sampler2D palette5;

uniform float weight1;
uniform float weight2;
uniform float weight3;
uniform float weight4;
uniform float weight5;

void fragment()
{
	// Capture the colour of the current screen fragment
	vec4 screen_fragment = texture(TEXTURE, UV);
	// Calculate the greyscale value of that fragment using the dot product
	// NOTE: This uses the "luminosity" method of greyscale conversion
	float greyscale = dot(screen_fragment.rgb, vec3(0.299, 0.587, 0.114));
	
	// Set the output based on the quantised value
	float wsum = weight1 + weight2 + weight3 + weight4 + weight5;
	float w1 = weight1 / wsum;
	float w2 = weight2 / wsum;
	float w3 = weight3 / wsum;
	float w4 = weight4 / wsum;
	float w5 = weight5 / wsum;
	
	vec2 lvl = vec2(greyscale, 0.0);
	vec4 output = texture(palette1, lvl) * w1 + texture(palette2, lvl) * w2 + texture(palette3, lvl) * w3 + texture(palette4, lvl) * w4 + texture(palette5, lvl) * w5;
	
	// Finalize the output and send it to the screen
	COLOR = output;
}