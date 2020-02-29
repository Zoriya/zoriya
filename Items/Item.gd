class_name Item
extends RigidBody


signal count_changed(new_count)

export var count := 1 setget set_count
export var item_name: String
export var stack_size := 1


func _ready() -> void:
	rpc_config("queue_free", MultiplayerAPI.RPC_MODE_SYNC)


func set_count(value: int) -> void:
	count = value
	emit_signal("count_changed", count)


func is_stackable() -> bool:
	return stack_size != 1


func add_to_stack(other_item: Item) -> void:
	if typeof(self) != typeof(other_item):
		return
	if count + other_item.count > stack_size:
		other_item.count -= stack_size - count
		set_count(stack_size)
	else:
		set_count(count + other_item.count)
		other_item.count = 0


func interaction_text() -> String:
	return "Pick [%s]\n%s" % [InputMap.get_action_list("pick").front().as_text(), item_name]
