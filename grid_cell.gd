class_name GridCell
extends StaticBody2D

@export var is_selected:bool = false:
		set = _set_is_selected

signal grid_cell_pressed(source)
signal grid_cell_hovered(source)
signal grid_cell_unpressed(source)

func _set_is_selected(value:bool):
	is_selected = value
	$SelectionSprite.visible = value
	queue_redraw()

func has_grid_item() -> bool:
	return $Container.get_child_count() > 0

func put_grid_item(grid_item:GridItem):
	$Container.add_child(grid_item)
	grid_item.position = Vector2.ZERO

func move_grid_item(grid_item:GridItem, animate:bool = false):
	grid_item.reparent($Container, true)
	if animate:
		var tween = create_tween()
		tween.tween_property(grid_item, "position", Vector2.ZERO, 0.1)
		tween.set_ease(Tween.EASE_OUT)
	else:
		grid_item.position = Vector2.ZERO

func get_grid_item() -> GridItem:
	return $Container.get_child(0) if has_grid_item() else null

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("touch"):
		grid_cell_pressed.emit(self)
		get_viewport().set_input_as_handled()
	elif event.is_action_released("touch"):
		grid_cell_unpressed.emit(self)
		get_viewport().set_input_as_handled()
	elif event.is_action_released("swap"):
		grid_cell_unpressed.emit(self)
		get_viewport().set_input_as_handled()
