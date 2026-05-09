shader_type spatial;
render_mode unshaded, blend_mix, depth_test_disabled, cull_disabled, fog_disabled;

uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform float radius : hint_range(0.0, 1.0) = 0.8;
uniform float softness : hint_range(0.01, 1.0) = 0.2;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);

    float dynamic_radius = mix(1.5, radius, intensity);

    float vignette = smoothstep(dynamic_radius - softness, dynamic_radius, dist);

    ALBEDO = vec3(0.0); 
    ALPHA = vignette * intensity; 
}