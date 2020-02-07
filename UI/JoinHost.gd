extends Control


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_load_world")


func _host() -> void:
	var host: = NetworkedMultiplayerENet.new()
	if host.create_server($Tabs/Host/Grid/Port.value, $Tabs/Host/Grid/MaxPlayers.value) == OK:
		get_tree().set_network_peer(host)
		_load_world()
	else:
		$ConnectionDialog.show_hosting_error()


func _join() -> void:
	var host: = NetworkedMultiplayerENet.new()
	if host.create_client($Tabs/Join/Grid/Ip.text, $Tabs/Join/Grid/Port.value) == OK:
		get_tree().set_network_peer(host)
		$ConnectionDialog.show_connecting()
	else:
		$ConnectionDialog.show_connection_failed()


func _load_world() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Core/Main.tscn")
