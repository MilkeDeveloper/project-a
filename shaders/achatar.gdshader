shader_type canvas_item;

uniform float rotation_speed : hint_range(0.0, 10.0); // Velocidade de rotação
uniform float flatten_factor : hint_range(0.1, 1.0); // Fator de achatamento
uniform vec3 color_ramp : source_color; // Rampa de cor
uniform float alpha : hint_range(0.0, 1.0, 0.1);

void fragment() {
    vec2 uv = UV;

    // Achatar a textura
    uv.y /= flatten_factor * 1.7;

    // Calcular a rotação
    float angle = TIME * rotation_speed;
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);
    
    // Transladar para o centro da textura
    uv -= vec2(0.5);
	uv += vec2(0.0);

    // Aplicar a rotação
    uv = vec2(
        uv.x * cos_angle - uv.y * sin_angle,
        uv.x * sin_angle + uv.y * cos_angle
    );

    // Transladar de volta para a posição original
    uv += vec2(0.5);
	
	vec4 color = texture(TEXTURE, uv);
	// Mantém o gradiente de cor ao longo do eixo Y
	color.rgb = mix(color.rgb, color_ramp, alpha);
	
	COLOR = vec4(color.rgb, color.a);
    // Aplicar a textura
   
}