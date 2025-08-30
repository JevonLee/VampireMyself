shader_type canvas_item;

uniform vec2 offset = vec2(1.1,0);
uniform vec2 repeat = vec2(1.,10.);


void fragment(){
	vec2 uv = UV * repeat + offset;
	vec4 orignal_color = texture(TEXTURE,uv);
	COLOR = orignal_color;
	
}