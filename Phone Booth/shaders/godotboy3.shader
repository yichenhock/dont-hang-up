shader_type canvas_item;

uniform sampler2D palette1;
uniform sampler2D palette2;
uniform sampler2D palette3;
uniform float weight1;
uniform float weight2;
uniform float weight3;

void fragment()
{
	// Capture the colour of the current screen fragment
	vec4 screen_fragment = texture(SCREEN_TEXTURE, SCREEN_UV);
	// Calculate the greyscale value of that fragment using the dot product
	// NOTE: This uses the "luminosity" method of greyscale conversion
	float greyscale = dot(screen_fragment.rgb, vec3(0.299, 0.587, 0.114));
	
	// Set the output based on the quantised value
	float wsum = weight1 + weight2 + weight3;
	float w1 = weight1 / wsum;
	float w2 = weight2 / wsum;
	float w3 = weight3 / wsum;

	vec2 lvl = vec2(greyscale, 0.0);
	vec4 output = texture(palette1, lvl) * w1 + texture(palette2, lvl) * w2 + texture(palette3, lvl) * w3;
	
	// Finalize the output and send it to the screen
	COLOR = output;
}