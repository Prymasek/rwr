shader_type spatial;
render_mode unshaded, blend_mix, depth_test_disabled, cull_disabled;

uniform float intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);
    float radius = 0.8;
    float softness = 0.4;
    float vignette = smoothstep(radius, radius - softness, dist);
    
    ALBEDO = vec3(0.0);
    ALPHA = (1.0 - vignette) * intensity;
}