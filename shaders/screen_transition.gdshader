shader_type canvas_item;

uniform vec4 base_color:source_color;
uniform float val:hint_range(0.0, 1.0, 0.1);
uniform sampler2D noise_texture;

void fragment(){
	vec4 noise_color = texture(noise_texture,UV);
	//vec4 orignal_color = texture(TEXTURE,UV);
	vec4 final_color = base_color;
	if (val>noise_color.r){
		final_color.a = 0.0;
	}
	
	COLOR = final_color;
}