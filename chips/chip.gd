var public_interface: Dictionary setget ,_get_public_interface

func _get_public_interface():
	var interface = {}
	interface["output_pins"] = _get_public_output_pin_interface()
	interface["input_pins"] = _get_public_input_pin_interface()
	return interface
    
func _get_public_input_pin_interface():
	var input_pins = []
	var input_pin_map = self.input_pin_map

	input_pins.resize(input_pin_map.size())

	for pin_name in self.input_pin_map:
		input_pins[self.input_pin_map[pin_name]] = {
			name = pin_name
		}

	return input_pins

func _get_public_output_pin_interface():
	var interface = {}
	var output_pins = []
	var output_pin_map = self.output_pin_map

	output_pins.resize(output_pin_map.size())

	for pin_name in output_pin_map:
		output_pins[output_pin_map[pin_name]] = {
			name = pin_name
		}

	return output_pins
