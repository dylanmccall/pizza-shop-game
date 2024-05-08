extends Node2D

@export var tile_size:int = 64

# In GridItem, add a collision node.
# Do a 2d ray cast to get the node under the mouse.
# Implement drag & drop tile movement.
# 

var selected_grid_item:GridItem = null

func _ready():
	pass

func _on_input_event(viewport, event, shape_idx):
	if not selected_grid_item:
		return

	if event.is_action_released("touch"):
		print("Trigger movement: ", selected_grid_item)
		deselect_grid_item()
		pass
	elif event is InputEventMouseMotion:
		print("Hint movement: ", selected_grid_item)
		pass
		
	get_viewport().set_input_as_handled()

func _on_tomato_grid_item_grid_item_touched(source):
	print("_on_tomato_grid_item_grid_item_touched: ", source)
	select_grid_item(source)

func select_grid_item(grid_item:GridItem):
	if selected_grid_item == grid_item:
		return
	elif selected_grid_item:
		selected_grid_item.is_selected = false

	if grid_item:
		grid_item.is_selected = true

	selected_grid_item = grid_item

func deselect_grid_item():
	select_grid_item(null)
