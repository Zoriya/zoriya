extends VBoxContainer


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "announce_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "announce_disconnected")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if $InputField.has_focus():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$InputField.release_focus()
	elif event.is_action_pressed("ui_accept"):
		if not $InputField.has_focus():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$InputField.accept_event()
			$InputField.grab_focus()


func announce_connected(id: int) -> void:
	$Panel/ChatWindow.bbcode_text += "\n[color=gray]%d has joined the game.[/color]" % id


func announce_disconnected(id: int) -> void:
	$Panel/ChatWindow.bbcode_text += "\n[color=gray]%d has left the game.[/color]" % id


func send_message(message: String) -> void:
	$InputField.clear()
	rpc("print_message", get_tree().get_network_unique_id(), message)


sync func print_message(id: int, message: String) -> void:
	$Panel/ChatWindow.bbcode_text += "\n[color=green]%d[/color]: %s" % [id, message]
