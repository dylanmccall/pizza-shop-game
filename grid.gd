class_name Grid
extends Area2D

# For simplicity, we will relate nodes to grid cells based on their position
# in the scene. This would be more flexible if we create an array of grid cell
# nodes where we move grid items between grid cells, but this approach is enough
# to get started.

@export var TILE_SIZE:Vector2 = Vector2(64, 64)

var grid_item_drag:GridItemDrag = null

func _ready():
	# TODO: Remove this once we are instantiating grid items properly
	for node in self.get_children():
		if node is GridItem:
			node.connect("grid_item_touched", _on_tomato_grid_grid_item_touched)

func _physics_process(delta):
	if grid_item_drag:
		grid_item_drag.update_from_raycast()

func _on_input_event(viewport, event, shape_idx):
	if not grid_item_drag:
		return

	grid_item_drag.update_target(get_local_mouse_position())
	
	if not grid_item_drag.is_significant():
		return

	if event.is_action_released("touch") or event.is_action_released("swap"):
		grid_item_drag.apply_movements()
		deselect_grid_item()
		get_viewport().set_input_as_handled()

func _on_tomato_grid_grid_item_touched(source):
	select_grid_item(source)

func select_grid_item(grid_item:GridItem):
	print("Select grid item", grid_item)
	if grid_item_drag and not grid_item_drag.get_grid_item() == grid_item:
		grid_item_drag.get_grid_item().is_selected = false
	
	if not grid_item:
		grid_item_drag = null
	else:
		grid_item_drag = GridItemDrag.new(self, grid_item)
		grid_item.is_selected = true

func deselect_grid_item():
	select_grid_item(null)

class GridItemDrag:
	enum Status {UNKNOWN, BLOCKED, ALLOWED, ANIMATING}

	var _grid:Grid
	var _grid_item:GridItem
	var _start:Vector2 = Vector2.INF
	var _target:Vector2 = Vector2.INF
	var _status:Status = Status.UNKNOWN
	var _swap_node:Node2D = null

	func _init(grid:Grid, grid_item:GridItem):
		self._grid = grid
		self._grid_item = grid_item
		self._update_start()
	
	func get_grid_item():
		return self._grid_item

	func _update_start():
		var start = self._grid_item.position.snapped(self._grid.TILE_SIZE)
		if start != self._start:
			self._start = start
			self._status = Status.UNKNOWN
	
	func is_significant() -> bool:
		return self._start != self._target

	func update_target(target:Vector2):
		target = target.snapped(self._grid.TILE_SIZE)
		if target != self._target:
			self._target = target
			self._status = Status.UNKNOWN
		self._update_start()

	func update_from_raycast():
		if self._status != Status.UNKNOWN:
			return
		
		if self._target == Vector2.INF:
			return

		var space_state = self._grid.get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = self._grid.to_global(self._target)
		query.exclude = [self._grid_item.get_rid()]
		var result = space_state.intersect_point(query, 1)
		result = result[0] if len(result) > 0 else null

		if not result:
			self._status = Status.ALLOWED
			self._swap_node = null
		elif not result.collider is GridItem:
			self._status = Status.BLOCKED
			self._swap_node = null
		else:
			self._status = Status.ALLOWED
			self._swap_node = result.collider

	func apply_movements():
		if self._status != Status.ALLOWED:
			return

		if self._status == Status.ANIMATING:
			return

		var tween = self._grid.create_tween()
		tween.set_parallel(true)
		tween.tween_property(self._grid_item, "position", self._target, 0.1)
		if self._swap_node:
			tween.tween_property(self._swap_node, "position", self._start, 0.1)
		tween.set_ease(Tween.EASE_OUT)
		
		self._status = Status.UNKNOWN
