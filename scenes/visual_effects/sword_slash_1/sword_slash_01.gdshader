shader_type canvas_item;

uniform vec2 offset = vec2(-0.5,0);
uniform float strength = 0.5;
uniform float val = 1.0;
uniform sampler2D noise_texture;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 orignal_color = texture(TEXTURE,UV+offset);
	vec4 noise_color = texture(noise_texture,UV);
	if (orignal_color.r<0.2){
		orignal_color.a = 0.0;
	}
	if(noise_color.r > val){
		orignal_color.a = 0.0;
	}
	if(orignal_color.r > val/4.0){
		orignal_color.b += 5.0;
	}
	COLOR = orignal_color;
}