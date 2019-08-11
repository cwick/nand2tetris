extends Reference

var _parts = {}
var _output_part_name = null
var _input_nodes = {}

func evaluate(input):
	if _parts.size() == 0:
		return false

	var output_node = _parts[_output_part_name]

	for n in _input_nodes:
		_input_nodes[n].bind_input(input)

	return output_node.evaluate()

func connect_part(part_name, part_input_pin, chip_input_pin_or_part_name):
	var node

	if typeof(chip_input_pin_or_part_name) == TYPE_INT:
		node = _get_input_node(chip_input_pin_or_part_name)
	else:
		node = _get_chip_node(chip_input_pin_or_part_name)

	_parts[part_name].add_child_at(node, part_input_pin)

func _get_input_node(chip_input_pin):
	var input_node

	if _input_nodes.has(chip_input_pin):
		input_node = _input_nodes[chip_input_pin]
	else:
		input_node = InputNode.new(chip_input_pin)
		_input_nodes[chip_input_pin] = input_node

	return input_node

func _get_chip_node(input_part_name):
	return _parts[input_part_name]

func add_part(part_name, part):
	_parts[part_name] = ChipNode.new(part)

func connect_output(part_name):
	_output_part_name = part_name


class ChipNode extends Reference:
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


class InputNode extends Reference:
	var _input
	var _selector

	func _init(selector):
		_selector = selector

	func bind_input(input):
		_input = input

	func evaluate():
		return _input[_selector]