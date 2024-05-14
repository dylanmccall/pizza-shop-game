@tool
class_name Grid
extends Node2D

const TILE_SIZE:Vector2i = Vector2i(64, 64)

@export var GRID_SIZE:Vector2i = Vector2i(9, 9):
	set = _set_grid_size

signal grid_changed(source:Grid)

var grid_cell_scene:Resource = load("res://grid_cell.tscn")

var cheese_scene:Resource = load("res://grid_items/cheese_grid_item.tscn")
var tomato_scene:Resource = load("res://grid_items/tomato_grid_item.tscn")

var selected_grid_cell:GridCell = null

func _ready():
	update_grid_cells()

func _set_grid_size(value:Vector2i):
	GRID_SIZE = value
	update_grid_cells()

func _on_grid_cell_pressed(grid_cell:GridCell):
	if grid_cell == selected_grid_cell:
		return

	var selected_grid_item = selected_grid_cell.get_grid_item() if selected_grid_cell else null
	var target_grid_item = grid_cell.get_grid_item() if grid_cell else null

	if selected_grid_item && !target_grid_item:
		print("Only if the target is empty, move the grid item from ", selected_grid_cell, " to ", grid_cell)
		grid_cell.move_grid_item(selected_grid_item, true)
		deselect_grid_cell()
	elif target_grid_item:
		select_grid_cell(grid_cell)

func _on_grid_cell_unpressed(grid_cell:GridCell):
	if grid_cell == selected_grid_cell:
		return

	var selected_grid_item = selected_grid_cell.get_grid_item() if selected_grid_cell else null
	var target_grid_item = grid_cell.get_grid_item() if grid_cell else null

	if selected_grid_item && target_grid_item:
		selected_grid_cell.move_grid_item(target_grid_item, true)
		grid_cell.move_grid_item(selected_grid_item, true)
	elif selected_grid_item:
		grid_cell.move_grid_item(selected_grid_item, true)

	deselect_grid_cell()

func update_grid_cells():
	for node in $GridCells.get_children():
		$GridCells.remove_child(node)
		node.queue_free()

	# This looks better in the editor if we arrange cells around a center point.
	var center = (GRID_SIZE - Vector2i.ONE) / 2

	for index in range(0, GRID_SIZE.x * GRID_SIZE.y):
		var grid_coordinate = get_coordinate_from_index(index)
		var grid_cell = grid_cell_scene.instantiate()
		grid_cell.position = (grid_coordinate - center) * TILE_SIZE
		if not Engine.is_editor_hint():
			grid_cell.connect("grid_cell_pressed", self._on_grid_cell_pressed)
			grid_cell.connect("grid_cell_unpressed", self._on_grid_cell_unpressed)
		$GridCells.add_child(grid_cell)

	if not Engine.is_editor_hint():
		get_grid_cell_from_index(1).put_grid_item(cheese_scene.instantiate())
		get_grid_cell_from_index(2).put_grid_item(cheese_scene.instantiate())
		get_grid_cell_from_index(3).put_grid_item(tomato_scene.instantiate())
		get_grid_cell_from_index(5).put_grid_item(tomato_scene.instantiate())
		get_grid_cell_from_index(6).put_grid_item(tomato_scene.instantiate())
		get_grid_cell_from_index(9).put_grid_item(cheese_scene.instantiate())

func get_coordinate_from_index(index:int) -> Vector2i:
	var index_x = index % GRID_SIZE.x
	@warning_ignore("integer_division")
	var index_y = index / GRID_SIZE.x
	return Vector2i(index_x, index_y)

func get_coordinate_from_grid_cell(grid_cell:GridCell) -> Vector2i:
	var index = grid_cell.get_index()
	return get_coordinate_from_index(index)

func get_index_from_coordinate(coordinate:Vector2i) -> int:
	return coordinate.x + (coordinate.y * GRID_SIZE.x)

func get_grid_cell_from_index(index:int) -> GridCell:
	return $GridCells.get_child(index)

func select_grid_cell(grid_cell:GridCell):
	if selected_grid_cell and grid_cell != selected_grid_cell:
		selected_grid_cell.is_selected = false

	if grid_cell:
		grid_cell.is_selected = true
	
	selected_grid_cell = grid_cell

func deselect_grid_cell():
	select_grid_cell(null)
