extends WindowDialog


signal inventory_is_full
signal pick_or_put_requested

const inventory_size: = 18


func _ready() -> void:
	#  Fill inventory with empty slots
	for _i in range(inventory_size):
		$ItemList.add_icon_item(Icon.icon_frame, false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if visible:
			visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			visible = true
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index == BUTTON_LEFT :
			var slot = _get_slot_under_cursor()
			if slot != -1:
				emit_signal("pick_or_put_requested", self, slot)


func pick_item(item: Item) -> void:
	#  Try to add to stack first
	if item.is_stackable():
		for i in range($ItemList.get_item_count()):
			if $ItemList.get_item_metadata(i) == null:
				continue
			$ItemList.get_item_metadata(i).item.add_to_stack(item)
			if item.count == 0:
				item.rpc("queue_free")
				return

	for slot in range($ItemList.get_item_count()):
		if $ItemList.get_item_metadata(slot) == null:
			var icon := preload("res://UI/Icon/Icon.tscn").instance()
			icon.set_item(item)
			put(slot, icon)
			return

	emit_signal("inventory_is_full")


func pop(slot: int) -> Icon:
	var icon: Icon = $ItemList.get_item_metadata(slot)
	if icon == null:
		return null

	remove(slot)
	return icon


func put_or_swap(slot: int, icon: Icon) -> Icon:
	var old_icon: Icon = $ItemList.get_item_metadata(slot)
	if old_icon != null:
		if old_icon.item.item_name == icon.item.item_name:
			old_icon.item.add_to_stack(icon.item)
			if icon.item.count == 0:
				return null
			return icon
		else:
			$Icons.remove_child(old_icon)

	put(slot, icon)
	return old_icon


func put(slot: int, icon: Icon) -> void:
	$Icons.add_child(icon)
	$ItemList.set_item_icon(slot, icon.get_texture())
	$ItemList.set_item_metadata(slot, icon)


func remove(slot: int) -> void:
	var icon: Icon = $ItemList.get_item_metadata(slot)
	if icon == null:
		return
	$Icons.remove_child(icon)
	$ItemList.set_item_icon(slot, null)
	$ItemList.set_item_metadata(slot, icon)


func _get_slot_under_cursor() -> int:
	return $ItemList.get_item_at_position($ItemList.get_local_mouse_position(), true)
