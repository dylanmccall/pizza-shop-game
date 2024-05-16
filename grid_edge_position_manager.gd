@tool
class_name GridEdgePositionManager
extends Node2D

enum Direction {
	ROW,
	COLUMN
}

@export var direction:Direction = Direction.ROW:
	set(value):
		direction = value
		_update_layout()
@export var index:int = 0:
	set(value):
		index = value
		_update_layout()

var grid: Grid

func _ready():
	grid = get_parent() as Grid
	
	connect("child_entered_tree", self._on_child_entered_tree)

	if not grid:
		push_warning("A GridEdgePositionManager must be a child of a Grid node")
		return

	_update_layout()

func _on_child_entered_tree(node:Node):
	_update_position_for_node(node)

func _update_layout():
	for node in self.get_children():
		_update_position_for_node(node)

func _update_position_for_node(node:Node):
	if not node is Node2D:
		return

	if not grid:
		return

	if direction == Direction.ROW:
		node.position = grid.get_grid_cell_position(Vector2i(grid.get_columns(), index))
	else:
		node.position = grid.get_grid_cell_position(Vector2i(index, grid.get_rows()))
