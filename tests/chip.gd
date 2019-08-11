extends Reference

var _parts = {}
var _connections = {}
var _output_part_name = null

func evaluate(input):
	if _parts.size() == 0:
		return false

	var output_node = ChipNode.new(_parts[_output_part_name])
	for part_input_pin in _connections:
		var chip_input_pin = _connections[part_input_pin]
		output_node.add_child_at(InputNode.new(input, chip_input_pin), part_input_pin)

	return output_node.evaluate()

func connect_part(part_name, part_input_pin, chip_input_pin):
	_connections[part_input_pin] = chip_input_pin

func add_part(part_name, part):
	_parts[part_name] = part

func connect_output(part_name):
	_output_part_name = part_name


class ChipNode:
	var _child_nodes = []
	var _chip

	func _init(chip):
		_chip = chip
		
	func evaluate():
		var input_values = []
		for child in _child_nodes:
			input_values.append(child.evaluate())
		return _chip.evaluate(input_values)

	func add_child_at(child, i):
		if i >= _child_nodes.size() - 1:
			_child_nodes.resize(i+1)

		_child_nodes[i] = child


class InputNode:
	var _input
	var _selector

	func _init(input, selector):
		_input = input
		_selector = selector

	func evaluate():
		return _input[_selector]