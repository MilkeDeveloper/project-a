shader_type canvas_item;

uniform bool shading = false;
uniform vec3 texture_color : source_color;
uniform float alpha : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.a *= COLOR.a;
	if (shading) {
		color.rgb = mix(color.rgb, texture_color, alpha);
		COLOR = vec4(color.rgb, color.a);
	} else {
		COLOR = color;
	}

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
