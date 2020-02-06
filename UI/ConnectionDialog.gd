extends PopupDialog


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "show_connection_failed")


func show_hosting_error() -> void:
	$Container/Text.set_text("Unable to create server")
	$Container/Button.set_text("Ok")
	popup_centered()


func show_connecting() -> void:
	$Container/Text.set_text("Connecting to server...")
	$Container/Button.set_text("Cancel")
	popup_centered()


func show_connection_failed() -> void:
	$Container/Text.set_text("Connection failed")
	$Container/Button.set_text("Ok")
	popup_centered()


func _close():
	get_tree().set_network_peer(null)
	hide()
