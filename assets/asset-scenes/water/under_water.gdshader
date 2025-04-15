shader_type canvas_item;

uniform float speed = 1.0;
uniform float strength = 0.02;
uniform float details = 3.0;
uniform vec4 water_tilt: source_color = vec4(0.1, 0.4, 0.7, 0.2);

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

float time_based_movement(float time, float time_speed, float offset) {
	return sin(time * time_speed + offset);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = SCREEN_UV;

	float x_displacement = time_based_movement(TIME, speed, uv.y * details) * strength;
	float y_displacement = time_based_movement(TIME, speed, uv.x * details) * strength;

	vec2 distorted_uv = uv;
	distorted_uv.x += x_displacement;
	distorted_uv.y += y_displacement;

	vec4 screen_color = texture(SCREEN_TEXTURE, distorted_uv);
	COLOR = mix(screen_color, water_tilt, water_tilt.a);

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
