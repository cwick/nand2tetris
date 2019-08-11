extends Reference

var parts = []
var input_pin_count = 0
var _connections = {}

func evaluate(input):
	if parts.size() == 0:
		return false

	var part_input = []
	part_input.resize(parts[0].input_pin_count)
	for i in range(parts[0].input_pin_count):
		part_input[i] = input[_connections[i]]

	return parts[0].evaluate(part_input)

func connect_part(part_name, part_input_pin, chip_input_pin):
	_connections[part_input_pin] = chip_input_pin