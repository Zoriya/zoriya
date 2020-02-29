extends Viewport


func set_item(item: Item) -> void:
	# Reparent
	item.get_parent().remove_child(item)
	add_child(item)

	# Set display properties
	item.mode = RigidBody.MODE_STATIC
	item.translation = Vector3.ZERO
	# warning-ignore:return_value_discarded
	item.connect("count_changed", self, "_display_count")
	_display_count(item.count)

func _display_count(count: int) -> void:
	$Count.text = str(count)
