extends Node2D

@export var is_selected:bool = false:
		set = _set_is_selected

signal grid_item_touched(source)

func _set_is_selected(value:bool):
	is_selected = value
	$SelectionSprite.visible = value
	queue_redraw()
