extends TileMap

@export var tile_size:int = 64

# In GridItem, add a collision node.
# Do a 2d ray cast to get the node under the mouse.
# Implement drag & drop tile movement.
# 

func _process(delta):
	process_input()

func process_input():
	if Input.is_action_just_pressed("touch"):
		var mouse_position = get_local_mouse_position()
		var start_map = local_to_map(mouse_position)
	elif Input.is_action_pressed("touch"):
		var mouse_position = get_local_mouse_position()
		# TODO: Offset the tile, indicating the direction it will move
		# TODO: After some threshold, move the tile if it is allowed
	elif Input.is_action_just_released("touch"):
		var mouse_position = get_local_mouse_position()
		var end_map = local_to_map(mouse_position)
