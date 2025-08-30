shader_type canvas_item;

uniform sampler2D number_texture:filter_nearest;
uniform vec4 final_color:source_color;
uniform int number;

void fragment(){
	float num = float(number);
	float digit_count = 0.0;
	for(int i=0;i<10;i++){
		if(num>0.0){
			num = floor(num/10.0);
			digit_count++;
		}
	}
}