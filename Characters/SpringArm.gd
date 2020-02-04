extends SpringArm


const ROTATION_SPEED := 0.005
const ZOOM_SPEED := 0.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * ROTATION_SPEED
		rotation.x -= event.relative.y * ROTATION_SPEED
		rotation.x = clamp(rotation.x, -PI / 2, 0)
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP:
				spring_length += ZOOM_SPEED
			BUTTON_WHEEL_DOWN:
				spring_length -= ZOOM_SPEED
