extends WindowDialog


signal inventory_is_full


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if visible:
			visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			visible = true


func pick_item(item: Item) -> void:
	#  Try to add to stack first
	if item.is_stackable():
		for button in $IconsContainer.get_children():
			if button.item == null:
				continue
			button.item.add_to_stack(item)
			if item.count == 0:
				item.rpc("queue_free")
				return

	for button in $IconsContainer.get_children():
		if button.item == null:
			button.set_item(item)
			return

	emit_signal("inventory_is_full")
