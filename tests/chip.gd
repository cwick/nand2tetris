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

func connect_part(part_name: String, part_pin: String, other_part: String):
	var node = _parts[other_part]
	var part = _parts[part_name]
	var part_pin_number = part.get_pin_number(part_pin)

	part.add_child_at(node, part_pin_number)

func connect_input(part_name: String, part_pin: String, input_pin: String):
	var part = _parts[part_name]
	var node = _input_nodes[input_pin]
	var part_pin_number = part.get_pin_number(part_pin)

	part.add_child_at(node, part_pin_number)

func connect_output(part_name: String):
	_output_part_name = part_name
	
func add_part(part_name, part):
	_parts[part_name] = ChipNode.new(part)

func add_input(pin_name, pin_number):
	_input_nodes[pin_name] = InputNode.new(pin_number)

func get_pin_number(pin_name):
	return _input_nodes[pin_name]._selector

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

	func get_pin_number(pin_name):
		return _chip.get_pin_number(pin_name)


class InputNode:
	var _input
	var _selector

	func _init(selector):
		_selector = selector

	func bind_input(input):
		_input = input

	func evaluate():
		if _selector >= _input.size():
			return false
		return _input[_selector]