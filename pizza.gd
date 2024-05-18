@tool
extends Area2D

@export var selected_toppings: Toppings.Type = 0:
	set(value):
		selected_toppings = value
		_update_visible_toppings()

var toppings_map: Dictionary = {}


func _ready():
	for index in $Crust.get_child_count():
		var node = $Crust.get_child(index)
		toppings_map[node.topping] = index
	_update_visible_toppings()


func _update_visible_toppings():
	for type in toppings_map:
		var node = $Crust.get_child(toppings_map[type])
		node.visible = selected_toppings & type
