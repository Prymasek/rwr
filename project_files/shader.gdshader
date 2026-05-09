shader_type spatial;
render_mode unshaded, blend_mix, depth_test_disabled, cull_disabled;

uniform float intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);

    float radius = 1.2 - (intensity * 0.5);
    float softness = 0.2;
    
    float alpha = smoothstep(radius - softness, radius, dist);

    ALBEDO = vec3(0.0); 
    ALPHA = alpha * intensity; 
}