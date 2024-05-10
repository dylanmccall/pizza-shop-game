extends Area2D

var toppings: int = 0
var toppings_map: Dictionary = {}


func _ready():
	for index in $Crust.get_child_count():
		var node = $Crust.get_child(index)
		toppings_map[node.topping] = index


func add_topping(type: Toppings.Type) -> void:
	if toppings & (1 << type):
		return

	print("Adding %s topping" % Toppings.get_type_name(type))
	var node = $Crust.get_child(toppings_map[type])
	node.visible = true
	toppings |= (1 << type)
