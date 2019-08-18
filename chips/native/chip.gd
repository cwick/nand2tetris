extends "../chip.gd"

func get_input_pin_number(pin_name):
    return self.input_pin_map[pin_name]["index"]

func get_output_pin_number(pin_name):
    return self.output_pin_map[pin_name]["index"]
