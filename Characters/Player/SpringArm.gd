extends SpringArm


const ROTATION_SPEED := 0.002
const ZOOM_SPEED := 0.5


func _ready() -> void:
	if is_network_master():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$Camera.set_current(true)
	else:
		set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cursor"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("zoom_in"):
		spring_length += ZOOM_SPEED
	elif event.is_action_pressed("zoom_out"):
		spring_length -= ZOOM_SPEED
	elif Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotation.y -= event.relative.x * ROTATION_SPEED
		rotation.x -= event.relative.y * ROTATION_SPEED
		rotation.x = clamp(rotation.x, -PI / 2, 0.7)
