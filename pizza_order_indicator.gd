@tool
class_name PizzaOrderIndicator
extends GridEdgePositionManager

var pizza_scene: PackedScene = load("res://pizza.tscn")
var pizza: Node2D = null


@export var toppings:int = 0:
	set(value):
		toppings = value
		_update_pizza()


func _ready():
	super._ready()

	pizza = pizza_scene.instantiate()
	add_child(pizza)
	
	_update_pizza()


func _update_pizza():
	if pizza:
		pizza.selected_toppings = toppings
