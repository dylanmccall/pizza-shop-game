extends Node2D

@onready var pizza = $Pizza2
var order: int


func reset():
	pizza.reset()
	order = Toppings.get_random_order()
	print_order()


func print_order():
	var names = []
	for type in Toppings.Type.values():
		if order & (1 << type):
			names.append(Toppings.get_type_name(type))
	print("Order: %s" % ", ".join(names))


func _ready():
	reset()


func _process(delta):
	if Input.is_action_just_pressed("new"):
		pizza.reset()


func _on_topping_picked(topping):
	pizza.add_topping(topping)
	if pizza.toppings == order:
		print("You win!")
		reset()
