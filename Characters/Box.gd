class_name Box
extends KinematicBody


const MOVE_SPEED = 10
const GRAVITY = -80
const JUMP_IMPULSE = 25

var input_enabled := true setget set_input_enabled
sync var health := 100

var _fall_speed: float


func _ready() -> void:
	if not is_network_master():
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	_fall_speed = move_and_slide(velocity(delta), Vector3.UP).y
	rpc_unreliable("update_transform", get_global_transform())


func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled


func change_health(value: int):
	rset("health", health + value)
	$DamageText.show_damage(value)


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


func velocity(delta: float) -> Vector3:
	var velocity: Vector3 = input_direction() * MOVE_SPEED
	if is_on_floor():
		if input_enabled and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_IMPULSE
		else:
			velocity.y = GRAVITY
	elif not is_on_ceiling():
		velocity.y = _fall_speed + GRAVITY * delta
	return velocity


remote func update_transform(transform: Transform) -> void:
	set_global_transform(transform)
