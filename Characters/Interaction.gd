extends RayCast


signal interaction_text_updated(text)


func _ready() -> void:
	if is_network_master():
		set_enabled(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pick"):
		var item: = get_collider() as Item
		if item != null:
			item.rpc("queue_free")

func _process(_delta: float) -> void:
	var collider: Object = get_collider()
	if collider != null and collider.has_method("interaction_text"):
		emit_signal("interaction_text_updated", collider.interaction_text())
	else:
		emit_signal("interaction_text_updated", "")

