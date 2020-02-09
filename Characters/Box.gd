extends KinematicBody

const MOVE_SPEED = 10
const GRAVITY = -80
const JUMP_IMPULSE = 25

var input_enabled := true setget set_input_enabled

var _velocity: Vector3


func _ready() -> void:
	if is_network_master():
		$SpringArm/Camera.set_current(true)
	else:
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	_velocity = calculate_velocity(move_and_slide(_velocity, Vector3.UP), delta)
	rpc_unreliable("update_transform", get_global_transform())


func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled


func input_direction() -> Vector3:
	if not input_enabled:
		return Vector3.ZERO
	
	var x_strength = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var z_strength = Input.get_action_strength("move_back") - Input.get_action_strength("move_front")
	
	var direction := Vector3()
	direction += $SpringArm.global_transform.basis.x * x_strength
	direction += $SpringArm.global_transform.basis.z * z_strength
	direction.y = 0
	return direction.normalized()


func calculate_velocity(old_velocity: Vector3, delta: float) -> Vector3:
	var new_velocity: Vector3 = input_direction() * MOVE_SPEED
	if is_on_floor():
		new_velocity.y = JUMP_IMPULSE if input_enabled and Input.is_action_just_pressed("jump") else GRAVITY
	elif not is_on_ceiling():
		new_velocity.y = old_velocity.y + GRAVITY * delta
	return new_velocity


remote func update_transform(transform: Transform) -> void:
	set_global_transform(transform)
