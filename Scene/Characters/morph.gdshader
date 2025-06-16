shader_type canvas_item;
uniform sampler2D image1;
uniform sampler2D image2;
uniform float blend : hint_range(0.0,1.0);

void fragment(){
	vec4 color1 = texture(image1,UV);
	vec4 color2 = texture(image2,UV);
	color1.rgb = vec3(1.0);
	color2.rgb = vec3(1.0);
	COLOR = (1.0-blend)*color1+ blend*color2;
}