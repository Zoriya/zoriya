class_name IconButton
extends Button


var item: Item setget set_item


func get_drag_data(_position: Vector2) -> IconButton:
	set_drag_preview(duplicate())
	return self


func can_drop_data(_position: Vector2, data) -> bool:
	return typeof(data) == typeof(self) and data != self


func drop_data(_position: Vector2, other_icon_button) -> void:
	var dropped_item: Item = other_icon_button.item
	other_icon_button.set_item(item)
	set_item(dropped_item)


func set_item(new_item: Item) -> void:
	if item != null:
		if item.get_parent() == $Icon:
			$Icon.remove_child(item)
		item.disconnect("count_changed", self, "_display_count")

	if new_item == null:
		icon = null
		item = null
		return

	if new_item.get_parent() != null:
		new_item.get_parent().remove_child(new_item)
	$Icon.add_child(new_item)
	item = new_item

	# Set display properties
	item.mode = RigidBody.MODE_STATIC
	item.translation = Vector3.ZERO
	item.rotation = Vector3.ZERO
	# warning-ignore:return_value_discarded
	item.connect("count_changed", self, "_display_count")
	_display_count(item.count)

	icon = $Icon.get_texture()


func _display_count(count: int) -> void:
	$Icon/Count.text = str(count)
