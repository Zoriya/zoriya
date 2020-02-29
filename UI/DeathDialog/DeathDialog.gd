extends PopupDialog


signal spirit_released


func release_spirit() -> void:
	emit_signal("spirit_released")
	hide()

func _show_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
