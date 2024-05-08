extends Node2D

@export var tile_size:int = 64
var snap_vector:Vector2 = Vector2(tile_size, tile_size)

var selected_grid_item:GridItem = null
var drag_target:Vector2 = Vector2.ZERO
var is_drag_allowed:bool = false

func _ready():
	pass

func _process(delta):
	if selected_grid_item and is_drag_allowed:
		# TODO: This should only happen when is_drag_allowed is first set
		var tween = create_tween()
		tween.tween_property(selected_grid_item, "position", drag_target, 0.1)
		tween.play()

func _physics_process(delta):
	if not selected_grid_item:
		return
		
	# TODO: Only do this once for a given selected_grid_item.position and drag_target

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(to_global(selected_grid_item.position), to_global(drag_target))
	var result = space_state.intersect_ray(query)

	if result:
		is_drag_allowed = false
	else:
		is_drag_allowed = true

func _on_input_event(viewport, event, shape_idx):
	if not selected_grid_item:
		return

	if event.is_action_released("touch"):
		deselect_grid_item()
		get_viewport().set_input_as_handled()
		return

	if not event is InputEventMouseMotion:
		return
	
	drag_target = get_local_mouse_position().snapped(snap_vector)

	get_viewport().set_input_as_handled()

func _on_tomato_grid_item_grid_item_touched(source):
	select_grid_item(source)

func select_grid_item(grid_item:GridItem):
	if selected_grid_item == grid_item:
		return
	elif selected_grid_item:
		selected_grid_item.is_selected = false

	if grid_item:
		drag_target = grid_item.position.snapped(snap_vector)
		grid_item.is_selected = true
	else:
		drag_target = Vector2.ZERO

	selected_grid_item = grid_item

func deselect_grid_item():
	select_grid_item(null)
