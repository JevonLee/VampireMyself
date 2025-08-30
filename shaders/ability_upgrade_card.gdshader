shader_type canvas_item;

uniform float val:hint_range(0.0, 1.0, 0.01) = 0.0;
uniform sampler2D noise_texture;

void fragment(){
	vec4 noise_color = texture(noise_texture,UV);
	vec4 orignal_color = texture(TEXTURE,UV);
	if (val>noise_color.r){
		orignal_color.a = 0.0;
	}
	COLOR = orignal_color;
}