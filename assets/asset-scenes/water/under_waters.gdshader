shader_type canvas_item;

uniform float speed = 1.0;
uniform float strength = 0.02;
uniform float frequency = 5.0;
uniform float ripple_growth = 0.5;
uniform vec4 water_tint: source_color = vec4(0.0, 0.2, 0.5, 0.3);

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float time_offset = TIME * speed;

	// Generate wavy distortion that moves upward in a ripple-like fashion
	float wave_x = sin(uv.y * frequency + time_offset) * strength;
	float wave_y = cos(uv.y * frequency * 0.5 + time_offset * 0.7) * strength;

	// Create a ripple effect that expands as it moves up
	float ripple = sin((uv.y + time_offset * 0.3) * ripple_growth) * strength * (1.0 - uv.y);

	vec2 distorted_uv = uv + vec2(wave_x, wave_y + ripple);

	vec4 screen_color = texture(SCREEN_TEXTURE, distorted_uv);
	COLOR = mix(screen_color, water_tint, water_tint.a);

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
