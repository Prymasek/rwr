extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15
@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController

func _physics_process(delta: float) -> void:
	# 1. Pobierz dane z joysticka
	var v: Vector2 = left_ctrl.get_vector2("thumbstick")
	
	# 2. Sprawdź deadzone
	if v.length() < deadzone:
		return

	# 3. Oblicz kierunki (wymuszenie typu Vector3 zapobiega błędom "infer type")
	var fwd: Vector3 = -xr_camera.global_transform.basis.z
	var right: Vector3 = xr_camera.global_transform.basis.x
	
	# Rzutowanie na płaszczyznę poziomą (kasujemy Y)
	fwd.y = 0.0
	right.y = 0.0
	fwd = fwd.normalized()
	right = right.normalized()

	# 4. Oblicz wektor ruchu 
	# v.y jest ujemne przy ruchu do przodu, więc dajemy minus przed v.y
	var dir: Vector3 = fwd * (-v.y) + right * (v.x)
	
	# 5. Wykonaj ruch
	if dir.length() > 0.0:
		global_translate(dir.normalized() * move_speed * delta)
