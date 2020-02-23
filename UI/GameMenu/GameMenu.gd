extends Panel


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	
	if is_visible():
		set_visible(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		set_visible(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _continue() -> void:
	hide()


func _exit() -> void:
	get_tree().quit(0)
