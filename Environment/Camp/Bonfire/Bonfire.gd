extends Spatial


func _start_dealing_damage(body: Node) -> void:
	if body is Box:
		var timer := Timer.new()
		timer.set_name(body.get_name() + "Timer")
		timer.set_wait_time(1)
		timer.set_autostart(true)
		# warning-ignore:return_value_discarded
		timer.connect("timeout", body, "change_health", [-10])
		add_child(timer)


func _stop_dealing_damage(body: Node) -> void:
	if body is Box:
		get_node(body.get_name() + "Timer").queue_free()
