shader_type canvas_item;

uniform float speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float angle : hint_range(0.0, 360.0, 0.1) = 0.0;
uniform float intensity : hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment(){
    vec4 tex_color = texture(TEXTURE, UV);

    // Rotate UV using angle uniform
    float rad = radians(angle);
    vec2 centered_uv = UV - 0.5;
    vec2 rotated_uv = vec2(
        centered_uv.x * cos(rad) - centered_uv.y * sin(rad),
        centered_uv.x * sin(rad) + centered_uv.y * cos(rad)
    ) + 0.5;

    float pulse = rotated_uv.x + rotated_uv.y;
    pulse = fract(pulse + TIME * speed);

    float x = 1.0 - abs(mod(pulse / (1.0/6.0), 2.0) - 1.0);

    vec3 rainbow;
    if(pulse < 1.0/6.0){
        rainbow = vec3(1.0, x, 0.0);
    } else if (pulse < 1.0/3.0) {
        rainbow = vec3(x, 1.0, 0.0);
    } else if (pulse < 0.5) {
        rainbow = vec3(0.0, 1.0, x);
    } else if (pulse < 2.0/3.0) {
        rainbow = vec3(0.0, x, 1.0);
    } else if (pulse < 5.0/6.0) {
        rainbow = vec3(x, 0.0, 1.0);
    } else {
        rainbow = vec3(1.0, 0.0, x);
    }

    COLOR = mix(tex_color, vec4(rainbow, tex_color.a), intensity);
}