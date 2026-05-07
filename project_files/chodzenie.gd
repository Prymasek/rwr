extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15

@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController


func _physics_process(delta: float) -> void:
	var input_dir := left_ctrl.get_vector2("thumbstick")

	# deadzone
	if input_dir.length() < deadzone:
		input_dir = Vector2.ZERO

	# kierunek kamery (płaszczyzna pozioma)
	var forward := -xr_camera.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()

	var right := xr_camera.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()

	# finalny kierunek ruchu
	var direction := (forward * input_dir.y + right * input_dir.x)

	if direction != Vector3.ZERO:
		# STABILNY RUCH XR (bez global_translate)
		global_position += direction.normalized() * move_speed * delta
