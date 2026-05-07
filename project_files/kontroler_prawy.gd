extends XRController3D

@onready var ray: RayCast3D = $TeleportRay
@onready var marker: MeshInstance3D = $TeleportMarker

@export var rotation_amount: float = 45.0 
@export var deadzone: float = 0.5           
var can_rotate: bool = true                 

var xr_origin: XROrigin3D
var xr_camera: XRCamera3D

func _ready() -> void:
	xr_origin = get_parent() as XROrigin3D
	if not xr_origin:
		push_error("Błąd: Kontroler musi być dzieckiem XROrigin3D!")
		return
		
	xr_camera = xr_origin.get_node("XRCamera3D") as XRCamera3D
	
	marker.visible = false
	
	button_pressed.connect(_on_button_pressed)

func _process(_delta: float) -> void:
	if ray.is_colliding():
		marker.visible = true
		marker.global_position = ray.get_collision_point()
		marker.global_basis = Basis() # Marker leży płasko
	else:
		marker.visible = false
	
	handle_snap_turn()

func _on_button_pressed(button_name: String) -> void:
	if button_name == "trigger_click":
		teleport_now()

func handle_snap_turn() -> void:
	var input := get_vector2("thumbstick")

	if abs(input.x) < deadzone:
		can_rotate = true 
		return

	if can_rotate:
		if input.x > 0:
			xr_origin.rotate_y(deg_to_rad(-rotation_amount))
		else:
			xr_origin.rotate_y(deg_to_rad(rotation_amount))
		
		can_rotate = false

func teleport_now() -> void:
	if not ray.is_colliding():
		return
		
	var target: Vector3 = ray.get_collision_point()

	var origin_tf := xr_origin.global_transform
	var cam_tf := xr_camera.global_transform
	var cam_offset := cam_tf.origin - origin_tf.origin
	
	cam_offset.y = 0.0 
	
	origin_tf.origin = target - cam_offset
	xr_origin.global_transform = origin_tf
