extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15
@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController
@onready var tunnel_material = $XRCamera3D/tunelowanie.get_surface_override_material(0)

func _physics_process(delta: float) -> void:
	var dir := Vector3.ZERO
	var fwd := -xr_camera.global_transform.basis.z; fwd.y = 0.0; fwd = fwd.normalized()
	var right := xr_camera.global_transform.basis.x; right.y = 0.0; right = right.normalized()

	var v: Vector2 = left_ctrl.get_vector2("thumbstick")
	var strength = v.length()
	
	if v.length() < deadzone:
		v = Vector2.ZERO

	dir += fwd * (v.y) + right * (v.x)
	
	if dir.length() > 0.0:
		global_translate(dir.normalized() * move_speed * delta)
	
	if tunnel_material:
		var current = tunnel_material.get_shader_parameter("intensity")
		var target = strength if strength > deadzone else 0.0
		var new_val = lerp(current, target, delta * 5.0)
		tunnel_material.set_shader_parameter("intensity", new_val)
