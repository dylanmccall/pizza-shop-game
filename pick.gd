extends Node2D


func _on_topping_picked(topping):
	$Pizza2.add_topping(topping)
