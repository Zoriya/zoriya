extends TextureRect
# Holds picked item from panels


# Picked item information
var _icon: Icon
var _slot: int
var _panel: WindowDialog


func _ready() -> void:
	set_process(false)


# Move icon by cursor
func _process(_delta: float) -> void:
	rect_position = get_viewport().get_mouse_position()


func drag(panel: WindowDialog, slot: int) -> void:
	if _panel == null:
		var icon = panel.pop(slot)
		if icon == null:
			return

		_icon = icon
		_slot = slot
		_panel = panel
		texture = _icon.get_texture()
		set_process(true)
	else:
		_icon = panel.put_or_swap(slot, _icon)
		if _icon != null:
			_panel.put(_slot, _icon)

		_slot = 0
		_panel = null
		texture = null
		set_process(false)
