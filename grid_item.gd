class_name GridItem

extends StaticBody2D

@export var is_selected:bool = false:
		set = _set_is_selected

signal grid_item_touched(source)

func _set_is_selected(value:bool):
	is_selected = value
	$SelectionSprite.visible = value
	queue_redraw()

func _on_input_event(_viewport, event, _shape_idx):
	if not event.is_action("touch"):
		return

	if not event.is_pressed():
		return

	grid_item_touched.emit(self)
	get_viewport().set_input_as_handled()
