class_name Icon
extends Viewport


const icon_frame: Resource = preload("res://UI/Icon/Slot.png")

var item: Item setget set_item


func set_item(new_item: Item) -> void:
	# Reparent
	new_item.get_parent().remove_child(new_item)
	add_child(new_item)
	item = new_item

	# Set display properties
	item.mode = RigidBody.MODE_STATIC
	item.translation = Vector3.ZERO
	item.rotation = Vector3.ZERO
	# warning-ignore:return_value_discarded
	item.connect("count_changed", self, "_display_count")
	_display_count(item.count)


func _display_count(count: int) -> void:
	$Count.text = str(count)
