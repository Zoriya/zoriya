extends SpringArm


const ROTATION_SPEED := 0.005

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * ROTATION_SPEED
		rotation.x -= event.relative.y * ROTATION_SPEED
		rotation.x = clamp(rotation.x, -PI / 2, 0)
