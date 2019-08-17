extends "../chip.gd"

var output_pin_count setget ,_get_output_pin_count

func get_input_pin_number(pin_name):
    return self.input_pin_map[pin_name]

func get_output_pin_number(pin_name):
    return self.output_pin_map[pin_name]

func _get_output_pin_count():
    return self.output_pin_map.size()
