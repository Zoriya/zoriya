extends Control


const FADE_TIME := 0.4
const SHOW_TIME := 1


func show_message(message: String) -> void:
	# Try to take one of the unused labels
	for label in $Messages.get_children():
		if label.modulate.a == 0:
			_animate(label, message)
			return

	# Use latest shown label
	var label: Label = $Messages.get_child(0)
	$Tween.reset(label)
	_animate(label, message)


func _animate(label: Label, message: String) -> void:
	label.modulate.a = 1
	label.text = message
	$Messages.move_child(label, $Messages.get_child_count() - 1)
	$Tween.interpolate_property(label, "modulate:a", 1, 0,
			FADE_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT, SHOW_TIME)
	$Tween.start()
