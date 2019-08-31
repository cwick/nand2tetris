func evaluate(input: Array) -> Array:
	_invalidate()
	return _evaluate(input)

func tick():
	# Overridden in child classes for sequential chips
	pass
	
func _evaluate(input: Array) -> Array:
	# Overridden in child classes
	return []
	
func _invalidate():
	# Overridden in child classes
	pass

func get_output_pins() -> Array:
	# Overridden in child classes
	return []

func get_input_pins() -> Array:
	# Overridden in child classes
	return []
	
func get_input_pin_number(pin_name) -> int:
	return _find_pin_index(pin_name, get_input_pins())

func get_output_pin_number(pin_name: String) -> int:
	return _find_pin_index(pin_name, get_output_pins())

func _find_pin_index(pin_name: String, pins: Array) -> int:
	for i in range(pins.size()):
		var pin = pins[i]
		if pin["name"] == pin_name:
			return i

	return -1