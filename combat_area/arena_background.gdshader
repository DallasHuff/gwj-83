shader_type canvas_item;

uniform vec2 texture_size;
uniform float time_speed : hint_range(0.0, 5.0) = 1.0;
uniform float bubble_strength : hint_range(0.0, 10.0) = 2.0;
uniform float bubble_radius_px : hint_range(1.0, 5.0) = 2.0; // radius in pixels
uniform vec4 target_color : source_color = vec4(0.388, 0.063, 0.0, 1.0); // #631000
uniform float color_tolerance : hint_range(0.0, 1.0) = 0.05;

void fragment() {
    vec2 uv = UV;
    vec4 color = texture(TEXTURE, uv);

    // Check if this pixel matches the target color within a small tolerance
    float color_diff = distance(color.rgb, target_color.rgb);
    if (color_diff < color_tolerance) {
        // Convert radius to UV space based on texture size
        float radius = bubble_radius_px / TEXTURE_PIXEL_SIZE.x; // assuming square pixels

        // Tiny shimmer effect over time
        float t = TIME * time_speed;
        float wave = sin(uv.x * 100.0 + t * 5.0) * cos(uv.y * 100.0 + t * 4.0);

        // Bubble shape intensity (centered on current pixel)
        float dist = length(fract(uv * texture_size) - 0.5);
        float bubble_mask = smoothstep(radius, radius * 0.5, dist);

        // Apply distortion (UV perturbation)
        vec2 offset = normalize(vec2(uv - 0.5)) * bubble_strength * 0.001 * bubble_mask * wave;
        vec4 distorted_color = texture(TEXTURE, uv + offset);

        // Tiny highlight for bubble sheen
        float highlight = pow(1.0 - dist / radius, 8.0) * bubble_mask * 0.2;

        COLOR = mix(color, distorted_color, bubble_mask);
        //COLOR.rgb += highlight;
    } else {
        COLOR = color;
    }
}