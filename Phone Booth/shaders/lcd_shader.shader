/*
	Glitch Effect Shader by Yui Kinomoto @arlez80
*/

shader_type canvas_item;

// 残像テクスチャ
uniform sampler2D residual_image_tex : hint_black_albedo;
// 残像の強さ
uniform float residual_image_rate : hint_range( 0.0, 1.0 ) = 0.95;
// ディザリング
uniform float dithering = 0.1;
// カラー液晶
uniform bool color_lcd = false;
// モノクロ液晶（明るいほう）
uniform vec4 monochrome_light : hint_color = vec4( 0.5372549019607843, 0.6274509803921569, 0.34765625, 1.0 );
// モノクロ液晶（暗くなるほう）
uniform vec4 monochrome_dark : hint_color = vec4( 0.19607843137254902, 0.22745098039215686, 0.1450980392156863, 1.0 );
// 液晶発色段階数
uniform int steps : hint_range( 2, 255 ) = 4;

float random( vec2 seed )
{
	return fract( 543.2543 * sin( dot( seed, vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment( )
{
	vec4 pixel_color = texture( SCREEN_TEXTURE, SCREEN_UV );
	float rand = random( SCREEN_UV );
	float steps_floated = float( steps );

	// ディザリング
	float dither_rand = rand * dithering - ( dithering * 0.5 );
	pixel_color = clamp( pixel_color + vec4( dither_rand, dither_rand, dither_rand, 0.0 ), vec4( 0.0, 0.0, 0.0, 0.0 ), vec4( 1.0, 1.0, 1.0, 1.0 ) );

	// カラーかモノクロか
	float monochrome = pixel_color.r * 0.2126 + pixel_color.g * 0.7152 + pixel_color.b * 0.0722;
	pixel_color = mix(
		mix( monochrome_dark, monochrome_light, floor( monochrome * steps_floated ) / steps_floated )
	,	floor( pixel_color * steps_floated) / steps_floated
	,	float( color_lcd )
	);

	// 残像と合成
	COLOR = mix( pixel_color, texture( residual_image_tex, UV ), residual_image_rate );
}
