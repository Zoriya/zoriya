extends Node


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_send_info")
	rpc("add_player", get_tree().get_network_unique_id())


sync func add_player(id: int) -> void:
	var player := preload("res://Characters/Box.tscn").instance()
	player.set_name("Player" + str(id))
	player.set_network_master(id)
	player.set_translation(Vector3(0, 10, 0))
	$World.add_child(player)


# Send player info to the new connected player
func _send_info(id: int) -> void:
	rpc_id(id, "add_player", get_tree().get_network_unique_id())
