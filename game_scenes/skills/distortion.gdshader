shader_type canvas_item;

uniform sampler2D source_texture;  // A textura que será distorcida
uniform sampler2D distortion_texture;  // A textura que define a distorção
uniform float distortion_strength = 0.05;  // Controle da intensidade da distorção

void fragment() {
    // Coordenadas da textura original
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    
    // Pega o valor da textura de distorção, normalmente usamos os canais R e G
    vec2 distortion = texture(distortion_texture, UV).rg;
    
    // Remapeia o valor de distorção de [-0.5, 0.5] para evitar distorções extremas
    distortion = (distortion - 0.5) * distortion_strength;

    // Aplica a distorção nas coordenadas UV
    vec2 distorted_uv = UV + distortion;

    // Pega a cor da textura original usando as coordenadas distorcidas
    COLOR = texture(source_texture, distorted_uv);
}