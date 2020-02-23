class_name Box
extends KinematicBody


signal died

const MOVE_SPEED = 10
const GRAVITY = -80
const JUMP_IMPULSE = 25
const MAX_HEALTH = 20

var input_enabled := true setget set_input_enabled
sync var health := MAX_HEALTH

var _fall_speed: float


func _ready() -> void:
	rpc_config("set_global_transform", MultiplayerAPI.RPC_MODE_REMOTE)
	rpc_config("set_translation", MultiplayerAPI.RPC_MODE_SYNC)

	if is_network_master():
		$SpringArm/Camera/Interaction.add_exception(self)
	else:
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	_fall_speed = move_and_slide(velocity(delta), Vector3.UP).y
	rpc_unreliable("set_global_transform", get_global_transform())


func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled


func change_health(value: int):
	if health <= 0:
		return
	$DamageText.show_damage(value)
	health = health + value
	if health <= 0:
		emit_signal("died")


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


func release_spirit():
	rpc("set_translation", Vector3(0, 10, 0))
	rset("health", MAX_HEALTH)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
