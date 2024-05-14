extends Node2D

@onready var pizza = $Pizza2
@onready var order_label = $Order
@onready var status_label = $Status
var order: int


func reset_pizza():
	status_label.text = ""
	pizza.reset()


func reset_order():
	order = Toppings.get_random_order()
	set_order_label()


func reset():
	reset_pizza()
	reset_order()


func set_order_label():
	var names = []
	for type in Toppings.Type.values():
		if order & (1 << type):
			names.append(Toppings.get_type_name(type))
	print("Order: %s" % ", ".join(names))
	order_label.text = "Order:\n%s" % "\n".join(names)


func _ready():
	reset()


func _process(_delta):
	if Input.is_action_just_pressed("new"):
		reset_pizza()


func _on_topping_picked(topping):
	pizza.add_topping(topping)
	if pizza.toppings == order:
		status_label.text = "LOOKS GOOD, DUDE!"
		print("You win!")
		await get_tree().create_timer(1).timeout
		reset()
	elif pizza.toppings & ~order:
		var topping_name = Toppings.get_type_name(topping)
		status_label.text = "BRO, I DIDN'T ORDER %s!" % topping_name


func _on_new_pizza_pressed():
	reset_pizza()
