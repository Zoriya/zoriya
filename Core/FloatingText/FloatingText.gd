extends Spatial


func show_damage(damage: int):
	var label := Label.new()
	label.add_font_override("font", preload("res://Core/FloatingText/AileronSemiBold.tres"))
	label.set_text("%+d" % damage)
	label.set_anchors_preset(Control.PRESET_CENTER)
	$Viewport.add_child(label)
	_animate(label)


func _animate(label: Label):
	$Tween.interpolate_property(label, "modulate:a", 1, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	$Tween.interpolate_property(label, "rect_scale", Vector2.ZERO, Vector2.ONE, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.interpolate_property(label, "rect_position:y", $Viewport.get_size().y, 0, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.interpolate_callback(label, 1, "queue_free")
	$Tween.start()
