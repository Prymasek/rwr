shader_type spatial;
// render_mode musi mieć te flagi, aby winieta była przezroczysta i na wierzchu
render_mode unshaded, blend_mix, depth_test_disabled, cull_disabled, fog_disabled;

uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform float radius : hint_range(0.0, 1.0) = 0.75;
uniform float softness : hint_range(0.01, 1.0) = 0.2;

void fragment() {
    // Mapowanie UV na współrzędne -1 do 1 (środek to 0,0)
    vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);

    // dynamic_radius: im wyższa intensywność, tym mniejszy okrąg widzenia
    float dynamic_radius = mix(1.4, radius, intensity);

    // smoothstep tworzy miękkie przejście między środkiem a czarnym brzegiem
    float vignette = smoothstep(dynamic_radius - softness, dynamic_radius, dist);

    ALBEDO = vec3(0.0); // Kolor czarny
    ALPHA = vignette * intensity; // Przezroczystość
}