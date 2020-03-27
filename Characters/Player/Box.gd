class_name Box
extends KinematicBody


signal died

const MOTION_INTERPOLATE_SPEED = 20
const VELOCITY_INTERPOLATE_SPEED = 2
const MOVE_SPEED = 10
const JUMP_IMPULSE = 4
const MAX_HEALTH = 20

var input_enabled := true setget set_input_enabled
sync var health := MAX_HEALTH

var _motion: Vector3
var _velocity: Vector3


func _ready() -> void:
	rpc_config("set_global_transform", MultiplayerAPI.RPC_MODE_REMOTE)
	rpc_config("set_translation", MultiplayerAPI.RPC_MODE_SYNC)

	if is_network_master():
		$SpringArm/Camera/Interaction.add_exception(self)
	else:
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	_motion = _motion.linear_interpolate(input_direction() * MOVE_SPEED, MOTION_INTERPOLATE_SPEED * delta)
	_velocity = move_and_slide(recalculate_velocity(delta), Vector3.UP, true)
	rpc_unreliable("set_global_transform", get_global_transform())


func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled


func change_health(value: int) -> void:
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


func recalculate_velocity(delta: float) -> Vector3:
	var new_velocity: Vector3
	if is_on_floor():
		new_velocity = _motion
		if input_enabled and Input.is_action_just_pressed("jump"):
			new_velocity.y = JUMP_IMPULSE
		else:
			new_velocity.y = -ProjectSettings.get_setting("physics/3d/default_gravity")
	else:
		new_velocity = _velocity.linear_interpolate(_motion, VELOCITY_INTERPOLATE_SPEED * delta)
		new_velocity.y = _velocity.y - ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	return new_velocity


func release_spirit() -> void:
	rpc("set_translation", Vector3(0, 30, 0))
	rset("health", MAX_HEALTH)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
