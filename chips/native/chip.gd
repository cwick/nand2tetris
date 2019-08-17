var output_pin_count setget ,_get_output_pin_count
var public_interface: Dictionary setget ,_get_public_interface

func get_input_pin_number(pin_name):
    return self.input_pin_map[pin_name]

func get_output_pin_number(pin_name):
    return self.output_pin_map[pin_name]

func _get_output_pin_count():
    return self.output_pin_map.size()

func _get_public_interface():
	var interface = {}
	var output_pins = []
	var input_pins = []
	output_pins.resize(self.output_pin_map.size())
	input_pins.resize(self.input_pin_map.size())

	for pin_name in self.output_pin_map:
		output_pins[self.output_pin_map[pin_name]] = {
			name = pin_name
		}

	for pin_name in self.input_pin_map:
		input_pins[self.input_pin_map[pin_name]] = {
			name = pin_name
		}

	interface["output_pins"] = output_pins
	interface["input_pins"] = input_pins
	return interface