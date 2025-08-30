shader_type canvas_item;

void fragment(){
	vec4 orignal_color = texture(TEXTURE,UV);
	if (orignal_color.r < 0.3){
		orignal_color.a = 0.0;
	}
	orignal_color.b += 10.;
	COLOR = orignal_color;
}