shader_type canvas_item;

uniform sampler2D noise_texture1:repeat_enable;
uniform sampler2D noise_texture2:repeat_enable;
uniform vec2 offset1 = vec2(0.5,0);
uniform vec2 offset2 = vec2(0.2,0);

void vertex(){
	UV.x = -UV.x;
}

void fragment(){
	vec4 orignal_color = texture(TEXTURE,UV);
	vec4 noise_color1 = texture(noise_texture1,UV + offset1*TIME);
	vec4 noise_color2 = texture(noise_texture2,UV + offset2*TIME);

	float gray_scale = (orignal_color.r + orignal_color.g + orignal_color.b)/3.0;
	if (orignal_color.r <= 0.2){
		orignal_color.a = 0.;
	}
	if (gray_scale >= 0.5){
		orignal_color.g = 10.;
	}
	//vec4 green = vec4(0.7,0.9,0.1,1);
	COLOR = orignal_color;

}