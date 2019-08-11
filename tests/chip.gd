var _parts = {}
var _output_part_name = null
var _input_nodes = {}

func evaluate(input):
	if _parts.size() == 0:
		return false

	if input.size() != _input_nodes.size():
		printerr("Not enough inputs. Expected %d inputs, got %d" % 
			[_input_nodes.size(), input.size()])
		return false

	var output_node = _parts[_output_part_name]

	for n in _input_nodes:
		_input_nodes[n].bind_input(input)

	return output_node.evaluate()

func connect_part(part_name, part_input_pin, pin_name):
	var node

	node = _input_nodes.get(pin_name)
	if node == null:
		node = _parts[pin_name]

	_parts[part_name].add_child_at(node, part_input_pin)

func add_part(part_name, part):
	_parts[part_name] = ChipNode.new(part)

func add_input(pin_name, pin_number):
	_input_nodes[pin_name] = InputNode.new(pin_number)

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

	func _init(selector):
		_selector = selector

	func bind_input(input):
		_input = input

	func evaluate():
		return _input[_selector]