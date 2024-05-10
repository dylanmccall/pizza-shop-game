extends MarginContainer

signal picked(topping: Toppings.Type)

func _ready():
	for node in $Bin.get_children():
		node.pressed.connect(_on_button_pressed.bind(node.topping))


func _on_button_pressed(topping: Toppings.Type):
	print("%s button pressed" % Toppings.get_type_name(topping))
	picked.emit(topping)
