# Toppings class and helper functions.

class_name Toppings

# Topping types.
# A named enum is just a Dictionary with a bit of syntatic sugar.
enum Type {
	SAUCE,
	CHEESE,
	SAUSAGE,
	PEPPERONI,
	GREEN_PEPPER,
	ONION,
	OLIVE,
	TOMATO,
}


# Get topping type name from value.
static func get_type_name(type: Type) -> String:
	return Type.find_key(type)


# Get topping type order weight.
static func get_type_weight(type: Type) -> int:
	match type:
		# Sauce and cheese are almost always ordered.
		Type.SAUCE, Type.CHEESE:
			return 4
	return 1


# Get the topping type Z order for stacking.
static func get_type_zorder(type: Type) -> int:
	match type:
		Type.SAUCE:
			return 0
		Type.CHEESE:
			return 1
	return 2


# Generate a random order. An array of topping types is returned.
# Each type is weighted by get_type_weight().
static func get_random_order() -> Array[Type]:
	var order: Array[Type] = []
	for v in Type.values():
		var r = randf_range(0.0, 1.0)
		var w = get_type_weight(v)
		if r * w >= 0.5:
			order.append(v)
	return order


static func get_type_image(type: Type) -> Image:
	var type_name = get_type_name(type).to_lower()
	var image_path = "res://art/toppings/%s.png" % type_name
	var image = Image.load_from_file(image_path)
	return image
