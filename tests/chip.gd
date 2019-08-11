extends Reference

var input_pin_count = 0
var _parts = {}
var _connections = {}
var _output_part_name = null

func evaluate(input):
	if _parts.size() == 0:
		return false

	var output_part = _parts[_output_part_name]
	var part_input = []

	part_input.resize(output_part.input_pin_count)
	for i in range(output_part.input_pin_count):
		part_input[i] = input[_connections[i]]

	return output_part.evaluate(part_input)

func connect_part(part_name, part_input_pin, chip_input_pin):
	_connections[part_input_pin] = chip_input_pin

func add_part(part_name, part):
	_parts[part_name] = part

func connect_output(part_name):
	_output_part_name = part_name