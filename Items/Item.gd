class_name Item
extends RigidBody


export var item_name: String


func _ready() -> void:
	rpc_config("queue_free", MultiplayerAPI.RPC_MODE_SYNC)


func interaction_text() -> String:
	return "Pick [%s]\n%s" % [InputMap.get_action_list("pick").front().as_text(), item_name]
