extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15

# Upewnij się, że te nazwy w $ pasują do Twojego drzewa sceny!
@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController

func _physics_process(delta: float) -> void:
	# SPRAWDZENIE: Czy kontroler jest aktywny?
	if not left_ctrl.get_is_active():
		# Jeśli to widzisz w konsoli, kontroler nie jest połączony/śledzony
		# print("Lewy kontroler nieaktywny") 
		return

	# Pobieramy wejście
	var v: Vector2 = left_ctrl.get_vector2("thumbstick")
	
	# DEBUG: Odkomentuj linię poniżej, żeby zobaczyć w konsoli czy liczby się zmieniają
	# print("Joystick: ", v)

	if v.length() < deadzone:
		return

	# Pobieramy bazę transformacji kamery
	var cam_basis: Basis = xr_camera.global_transform.basis
	
	# Kierunki przód/prawo z wyzerowanym Y
	var fwd: Vector3 = -cam_basis.z
	var right: Vector3 = cam_basis.x
	
	fwd.y = 0.0
	right.y = 0.0
	
	# Ważne: Normalizacja po wyzerowaniu Y
	fwd = fwd.normalized()
	right = right.normalized()

	# Obliczamy kierunek ruchu
	# W OpenXR: góra to -Y, dół to +Y, dlatego używamy -v.y
	var dir: Vector3 = (fwd * -v.y) + (right * v.x)
	
	if dir.length() > 0.0:
		# Używamy global_position zamiast global_translate dla większej pewności
		global_position += dir.normalized() * move_speed * delta
