shader_type spatial;
render_mode specular_schlick_ggx;

uniform float speed : hint_range(0.5, 3.0) = 1.0;
uniform float amount : hint_range(0.05, 0.5) = 0.2;
uniform vec4 color: hint_color = vec4(0.3, 0.6, 0.8, 1.0);
uniform float transparency: hint_range(0.1, 20.0) = 0.4;

float phase(float value) {
	return mod(value, amount) / amount;
}

float offset_radians(float phase, float path, float frequency, float multiplier) {
	const float two_PI = 2.0 * 3.14;
	return two_PI * (phase + path * frequency * multiplier);
}

float generate_offset(vec3 vertex, float c1, float c2, float path)
{
	float phase_x = phase(vertex.x + vertex.z * vertex.x * c1);
	float frequency_x = mod(vertex.x * 0.8 + vertex.z, 1.5);
	float radians_x = offset_radians(phase_x, path, frequency_x, 1.0);

	float frequency_yz = mod(vertex.x, 2.0);

	float phase_y = phase(c2 * (vertex.z * vertex.x + vertex.x * vertex.z + vertex.y * vertex.x + vertex.y * vertex.z));
	float radians_y = offset_radians(phase_y, path, frequency_yz, 2.0);

	float phase_z = phase(c2 * (vertex.z * vertex.x + vertex.x * vertex.z));
	float radians_z = offset_radians(phase_z, path, frequency_yz, 2.0);

	return amount * 0.5 * (cos(radians_x) + cos(radians_y) + sin(radians_z));
}

void vertex() {
	float path = TIME * 0.1 * speed;

	float xd = generate_offset(VERTEX, 0.2, 0.1, path);
	float yd = generate_offset(VERTEX, 0.1, 0.3, path);
	float zd = generate_offset(VERTEX, 0.15, 0.2, path);

	VERTEX.x += xd;
	VERTEX.y += yd;
	VERTEX.z += zd;
}

void fragment() {
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
	ROUGHNESS = 0.2;

	vec2 refraction_uv = SCREEN_UV + NORMAL.xy * 0.075 / PROJECTION_MATRIX[2][2] / VERTEX.z;
	float depth_blend = 2.0 * texture(DEPTH_TEXTURE, refraction_uv).r - 1.0;
	depth_blend = PROJECTION_MATRIX[3][2] / (depth_blend + PROJECTION_MATRIX[2][2]);
	depth_blend = exp((VERTEX.z + depth_blend) * -transparency);
	depth_blend = min(depth_blend, 1.0);

	EMISSION = textureLod(SCREEN_TEXTURE, refraction_uv, ROUGHNESS * 8.0).rgb * depth_blend;
	ALBEDO = color.rgb * (1.0 - depth_blend);
}
