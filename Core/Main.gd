extends Node


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_send_info")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_remove_player")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	rpc("add_player", get_tree().get_network_unique_id())


sync func add_player(id: int) -> void:
	var player := preload("res://Characters/Player/Box.tscn").instance()
	player.set_name("Player" + str(id))
	player.set_network_master(id)
	player.set_translation(Vector3(0, 10, 0))
	$World.add_child(player)

	if get_tree().get_network_unique_id() == id:
		# warning-ignore:return_value_discarded
		$Chat/InputField.connect("focus_entered", player, "set_input_enabled", [false])
		# warning-ignore:return_value_discarded
		$Chat/InputField.connect("focus_exited", player, "set_input_enabled", [true])
		# warning-ignore:return_value_discarded
		$DeathDialog.connect("spirit_released", player, "release_spirit")
		# warning-ignore:return_value_discarded
		player.connect("died", $DeathDialog, "popup_centered")
		# warning-ignore:return_value_discarded
		player.get_node("SpringArm/Camera/Interaction").connect("interaction_text_updated", $Crosshair, "set_text")
		# warning-ignore:return_value_discarded
		player.get_node("SpringArm/Camera/Interaction").connect("item_picked", $Inventory, "pick_item")


func _remove_player(id: int) -> void:
	get_node("World/Player%d" % id).queue_free()


# Send player info to the new connected player
func _send_info(id: int) -> void:
	rpc_id(id, "add_player", get_tree().get_network_unique_id())

func _on_server_disconnected() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/JoinHost.tscn")
	OS.alert("You have been disconnected from the server", "Connection lost")
