extends Area2D

@export var velocity: int = 200
@export var start_x: int = -100
@export var stop_x: int = 50
var toppings: int = 0
var toppings_map: Dictionary = {}


func reset():
	position.x = start_x
	toppings = 0
	for node in $Crust.get_children():
		node.visible = false


func _ready():
	reset()
	for index in $Crust.get_child_count():
		var node = $Crust.get_child(index)
		toppings_map[node.topping] = index


func _process(delta):
	if position.x < stop_x:
		position.x = min(stop_x, position.x + velocity * delta)


func add_topping(type: Toppings.Type) -> void:
	if position.x < stop_x:
		return

	if toppings & (1 << type):
		return

	print("Adding %s topping" % Toppings.get_type_name(type))
	var node = $Crust.get_child(toppings_map[type])
	node.visible = true
	toppings |= (1 << type)
