@tool
class_name Main
extends Node


var max_pizza_orders: int = 0
var pizza_orders: Array[PizzaOrderIndicator] = []


func _ready():
	_refresh_pizza_orders()


func _refresh_pizza_orders():
	for order in pizza_orders:
		$Grid.remove_child(order.indicator)
		order.indicator.queue_free()

	max_pizza_orders = $Grid.get_rows() # + $Grid.get_columns()
	pizza_orders = []
	pizza_orders.resize(max_pizza_orders)

	var needed_toppings = []
	for order_number in range(max_pizza_orders):
		var order = _add_pizza_order(order_number)
		pizza_orders[order_number] = order
		for type in Toppings.Type.values():
			if order.toppings & type:
				needed_toppings.append(type)

	var grid_indices = range($Grid.get_rows() * $Grid.get_columns())
	grid_indices.shuffle()
	for i in range(needed_toppings.size()):
		$Grid.set_grid_item_topping(grid_indices[i], needed_toppings[i])


func _add_pizza_order(order_number: int) -> PizzaOrderIndicator:
	var order = PizzaOrderIndicator.new()
	order.toppings = Toppings.get_random_order()
	if order_number < $Grid.get_rows():
		order.direction = GridEdgePositionManager.Direction.ROW
		order.index = order_number
	elif order_number < $Grid.get_rows() + $Grid.get_columns():
		order.direction = GridEdgePositionManager.Direction.COLUMN
		order.index = order_number - $Grid.get_rows()
	$Grid.add_child(order)
	return order


func _on_grid_grid_changed(_source: Grid):
	pass
