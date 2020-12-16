shader_type canvas_item; 
uniform vec4 background_color: hint_color; 
// uniform sampler2D diffuse; 

void fragment(){ 
	vec4 col = texture(TEXTURE,UV).rgba;
	if (col == background_color){
		col.a=0.0;
	}
	COLOR=col;
}