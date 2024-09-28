shader_type canvas_item;

uniform sampler2D noise_texture: repeat_enable; // Textura de noise ou outra textura para aplicar o efeito
uniform sampler2D gradient_texture;
uniform vec2 pan_speed = vec2(0.5, 0.0); // Velocidade de movimento do noise
uniform vec4 color_ramp : source_color;

void fragment() {
    // Panning no noise (movimento ao longo do tempo)
	vec2 noise_uv =  UV  + TIME * pan_speed;
    // Cor da textura principal (fireball)
    vec4 fireball_color = texture(TEXTURE, UV);
    // Cor da textura de noise (aplicando movimento com o panning)
    vec4 noise_effect = texture(noise_texture, noise_uv);
	vec4 gradient = texture(gradient_texture, noise_uv);

	float texture_clamped = noise_effect.r - gradient.r;
    // Aplicando o noise apenas na parte visível da fireball
	float noise_r = noise_effect.r;
	vec4 transparent_noise = noise_effect - noise_r;

	vec4 final_color = mix(fireball_color, noise_effect, gradient);
	vec4 final_color_clamped = final_color * texture_clamped;
	// Ajustar o alfa final com base no alfa da fireball
    // Definindo a cor final do fragmento
	vec4 final_color_add = clamp(final_color_clamped, 0, 1);
    COLOR = final_color * color_ramp;
	//COLOR.a =

}