shader_type canvas_item;

uniform float lerp_percent:hint_range(0.0, 1.0, 0.001);
uniform vec4 flash_color :source_color = vec4(1);

void fragment(){
	vec4 orignal_color = texture(TEXTURE,UV);
	vec4 final_color = mix(orignal_color,vec4(vec3(1.),orignal_color.a),lerp_percent);
	
	COLOR = final_color;
	
}