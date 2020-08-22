shader_type canvas_item;

//uniform float amount_x = 1.0;
//uniform float amount_y = 1.0;

uniform vec2 amount = vec2(1.0,1.0);

uniform sampler2D offset_texture: hint_white; 

void fragment(){
	vec4 texture_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 color = texture_color;
	
//	float adjusted_amount_x = amount_x * texture(offset_texture, SCREEN_UV).r / 100.0;
//	float adjusted_amount_y = amount_y * texture(offset_texture, SCREEN_UV).b / 100.0;
	vec2 adjusted_amount = vec2(amount.x * texture(offset_texture, SCREEN_UV).r / 100.0,amount.y * texture(offset_texture, SCREEN_UV).b / 100.0);
	
	color.r = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + adjusted_amount.x,SCREEN_UV.y + adjusted_amount.y)).r;
	color.g = texture(SCREEN_TEXTURE,SCREEN_UV).g;
	color.b = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x - adjusted_amount.x,SCREEN_UV.y - adjusted_amount.y)).b;
	
	COLOR = color;
}