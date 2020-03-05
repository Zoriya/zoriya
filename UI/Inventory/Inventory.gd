extends WindowDialog


signal inventory_is_full

const inventory_size: = 18


func _ready() -> void:
	#  Fill inventory with empty slots
	for _i in range(inventory_size):
		$ItemList.add_icon_item(Item.icon_frame, false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible


func pick_item(item: Item) -> void:
	#  Try to add to stack first
	if item.is_stackable():
		for i in range($ItemList.get_item_count()):
			if $ItemList.get_item_metadata(i) == null:
				continue
			$ItemList.get_item_metadata(i).add_to_stack(item)
			if item.count == 0:
				item.rpc("queue_free")
				return

	for slot in range($ItemList.get_item_count()):
		if $ItemList.get_item_metadata(slot) == null:
			var icon := preload("res://UI/Icon/Icon.tscn").instance()
			icon.set_item(item)
			$Icons.add_child(icon)
			$ItemList.set_item_metadata(slot, item)
			$ItemList.set_item_icon(slot, icon.get_texture())
			return

	emit_signal("inventory_is_full")
