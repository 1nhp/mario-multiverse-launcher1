shader_type canvas_item;

uniform vec2 _CirclePosition = vec2(0.5);
uniform float _Progress : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float _Smoothness : hint_range(0.0, 0.1, 0.01) = 0.03;
uniform vec3 _Background : source_color;

void fragment()
{
	float r = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 position = _CirclePosition * vec2(r, 1.0);
	vec2 new_uv = SCREEN_UV * vec2(r, 1.0);
	
	float far_x = float(_CirclePosition.x < 0.5) * r;
	float far_y = float(_CirclePosition.y < 0.5);
	float r_max = distance(position, vec2(far_x,far_y));
	
	float new_progress = r_max * (1.0 - _Progress);
	float f = mix(new_progress, new_progress + _Smoothness, new_progress);
	float mask = smoothstep(new_progress, f, distance(new_uv, position));

	COLOR = vec4(_Background, mask);
}
