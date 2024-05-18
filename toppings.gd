# Toppings class and helper functions.

class_name Toppings

# Topping types.
# A named enum is just a Dictionary with a bit of syntatic sugar.
enum Type {
	NONE = 0,
	SAUCE = 1 << 0,
	CHEESE = 1 << 1,
	SAUSAGE = 1 << 2,
	PEPPERONI = 1 << 3,
	GREEN_PEPPER = 1 << 4,
	ONION = 1 << 5,
	OLIVE = 1 << 6,
	TOMATO = 1 << 7,
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


# Generate a random order. An bitfield of topping types is returned.
# Each type is weighted by get_type_weight().
static func get_random_order() -> int:
	var order: int = 0
	for v in Type.values():
		var r = randf_range(0.0, 1.0)
		var w = get_type_weight(v)
		if r * w >= 0.5:
			order |= v
	return order


static func get_type_image(type: Type) -> Image:
	var type_name = get_type_name(type).to_lower()
	var image_path = "res://art/toppings/%s.png" % type_name
	var image = Image.load_from_file(image_path)
	return image
