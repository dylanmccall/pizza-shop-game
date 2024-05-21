@tool
class_name Main
extends Node


var max_pizza_orders: int = 0
var pizza_orders: Array[PizzaOrderIndicator] = []


func _refresh_pizza_orders():
	for order in pizza_orders:
		$Grid.remove_child(order)
		order.queue_free()

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


func _check_pizza_orders() -> bool:
	for order_number in range(pizza_orders.size()):
		var order = pizza_orders[order_number]
		var applied_toppings:int
		if order_number < $Grid.get_rows():
			applied_toppings = $Grid.get_grid_item_toppings_for_row(order_number)
		else:
			applied_toppings = $Grid.get_grid_item_toppings_for_column(order_number - $Grid.get_rows())

		if applied_toppings != order.toppings:
			return false

	return true


func _on_grid_grid_changed(_source: Grid):
	pass


func _update_status():
	$Grid.active = false
	var matched:bool = _check_pizza_orders()
	if matched:
		$UI.set_message("LOOKS GOOD, DUDE!")
	else:
		$UI.set_message("BRO, THAT'S NOT WHAT I ORDERED!")


func _on_ui_countdown_timeout():
	_update_status()


func _on_ui_ready_pressed():
	_update_status()


func _on_ui_start_pressed():
	$UI.set_message("")
	$Grid.clear_grid_cells()
	_refresh_pizza_orders()
	$Grid.active = true
	$UI.start_countdown()
