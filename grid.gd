@tool
class_name Grid
extends Node2D

const TILE_SIZE:Vector2i = Vector2i(64, 64)

## The size of the grid in rows and columns.
@export var GRID_SIZE:Vector2i = Vector2i(9, 9):
	set(value):
		GRID_SIZE = value
		_update_grid_cells()

signal grid_changed(source:Grid)

var grid_cell_scene:Resource = load("res://grid_cell.tscn")

var topping_scenes:Dictionary = {
	Toppings.Type.SAUCE: load("res://grid_items/sauce_grid_item.tscn"),
	Toppings.Type.CHEESE: load("res://grid_items/cheese_grid_item.tscn"),
	Toppings.Type.SAUSAGE: load("res://grid_items/sausage_grid_item.tscn"),
	Toppings.Type.PEPPERONI: load("res://grid_items/pepperoni_grid_item.tscn"),
	Toppings.Type.GREEN_PEPPER: load("res://grid_items/green_pepper_grid_item.tscn"),
	Toppings.Type.ONION: load("res://grid_items/onion_grid_item.tscn"),
	Toppings.Type.OLIVE: load("res://grid_items/olive_grid_item.tscn"),
	Toppings.Type.TOMATO: load("res://grid_items/tomato_grid_item.tscn"),
}

var topping_scene_paths:Dictionary = {}

var selected_grid_cell:GridCell = null

func _ready():
	for type in topping_scenes.keys():
		var scene = topping_scenes[type]
		topping_scene_paths[scene.resource_path] = type
	_update_grid_cells()


func _on_grid_cell_pressed(grid_cell:GridCell):
	if grid_cell == selected_grid_cell:
		return

	var selected_grid_item = selected_grid_cell.get_grid_item() if selected_grid_cell else null
	var target_grid_item = grid_cell.get_grid_item() if grid_cell else null

	if selected_grid_item && !target_grid_item:
		print("Only if the target is empty, move the grid item from ", selected_grid_cell, " to ", grid_cell)
		grid_cell.move_grid_item(selected_grid_item, true)
		_deselect_grid_cell()
		emit_signal("grid_changed", self)
	elif target_grid_item:
		_select_grid_cell(grid_cell)

func _on_grid_cell_unpressed(grid_cell:GridCell):
	if grid_cell == selected_grid_cell:
		return

	var selected_grid_item = selected_grid_cell.get_grid_item() if selected_grid_cell else null
	var target_grid_item = grid_cell.get_grid_item() if grid_cell else null

	if selected_grid_item && target_grid_item:
		selected_grid_cell.move_grid_item(target_grid_item, true)
		grid_cell.move_grid_item(selected_grid_item, true)
		emit_signal("grid_changed", self)
	elif selected_grid_item:
		grid_cell.move_grid_item(selected_grid_item, true)
		emit_signal("grid_changed", self)

	_deselect_grid_cell()

func _update_grid_cells():
	for node in $GridCells.get_children():
		$GridCells.remove_child(node)
		node.queue_free()

	for index in range(0, GRID_SIZE.x * GRID_SIZE.y):
		var grid_cell = grid_cell_scene.instantiate()
		grid_cell.position = get_grid_cell_position(
			_get_coordinate_from_index(index)
		)
		if not Engine.is_editor_hint():
			grid_cell.connect("grid_cell_pressed", self._on_grid_cell_pressed)
			grid_cell.connect("grid_cell_unpressed", self._on_grid_cell_unpressed)
		$GridCells.add_child(grid_cell)

func _get_coordinate_from_index(index:int) -> Vector2i:
	var index_x = index % GRID_SIZE.x
	@warning_ignore("integer_division")
	var index_y = index / GRID_SIZE.x
	return Vector2i(index_x, index_y)

func _get_index_from_coordinate(coordinate:Vector2i) -> int:
	return coordinate.x + (coordinate.y * GRID_SIZE.x)

func _get_grid_cell_from_index(index:int) -> GridCell:
	return $GridCells.get_child(index)

func _get_grid_cell_from_coordinate(coordinate:Vector2i) -> GridCell:
	return _get_grid_cell_from_index(_get_index_from_coordinate(coordinate))

func _get_grid_item_from_coordinate(coordinate:Vector2i) -> GridItem:
	var grid_cell = _get_grid_cell_from_coordinate(coordinate)
	return grid_cell.get_grid_item() if grid_cell else null

func _select_grid_cell(grid_cell:GridCell):
	if selected_grid_cell and grid_cell != selected_grid_cell:
		selected_grid_cell.is_selected = false

	if grid_cell:
		grid_cell.is_selected = true
	
	selected_grid_cell = grid_cell

func _deselect_grid_cell():
	_select_grid_cell(null)

func get_grid_cell_position(grid_coordinate: Vector2i) -> Vector2i:
	# This looks better in the editor if we arrange cells around a center point.
	var center = (GRID_SIZE - Vector2i.ONE) / 2
	return (grid_coordinate - center) * TILE_SIZE

func get_columns() -> int:
	return GRID_SIZE.x

func get_rows() -> int:
	return GRID_SIZE.y

func get_width() -> int:
	return GRID_SIZE.x * TILE_SIZE.x

func get_height() -> int:
	return GRID_SIZE.y * TILE_SIZE.y

func get_grid_items_for_column(column:int) -> Array[GridItem]:
	var result:Array[GridItem] = []
	for row in range(get_rows()):
		result.append(_get_grid_item_from_coordinate(Vector2i(column, row)))
	return result

func get_grid_items_for_row(row:int) -> Array[GridItem]:
	var result:Array[GridItem] = []
	for column in range(get_columns()):
		result.append(_get_grid_item_from_coordinate(Vector2i(column, row)))
	return result

func set_grid_item_topping(index:int, type:Toppings.Type):
	_get_grid_cell_from_index(index).put_grid_item(
		topping_scenes[type].instantiate()
	)

func get_grid_item_topping(item:GridItem) -> Toppings.Type:
	if item == null:
		return Toppings.Type.NONE
	return topping_scene_paths.get(item.scene_file_path, Toppings.Type.NONE)

func get_grid_item_toppings_for_row(row:int) -> int:
	var toppings:int = 0
	for item in get_grid_items_for_row(row):
		toppings |= get_grid_item_topping(item)
	return toppings

func get_grid_item_toppings_for_column(column:int) -> int:
	var toppings:int = 0
	for item in get_grid_items_for_row(column):
		toppings |= get_grid_item_topping(item)
	return toppings
