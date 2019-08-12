var _parts = {}
var _output_nodes = {}
var _input_nodes = {}

func evaluate(input):
	for node in _input_nodes.values():
		node.bind_input(input)

	var output = []
	output.resize(_output_nodes.size())

	for node in _output_nodes.values():
		var value = node.evaluate()
		output[node.output_pin_number] = value

	return output

func connect_part(part_name: String, part_pin: String, other_part: String):
	var node = _parts[other_part]
	var part = _parts[part_name]
	var part_pin_number = part.get_input_pin_number(part_pin)

	part.add_child_at(node, part_pin_number)

func connect_input(part_name: String, part_pin: String, input_pin: String):
	var part = _parts[part_name]
	var node = _input_nodes[input_pin]
	var part_pin_number = part.get_input_pin_number(part_pin)

	part.add_child_at(node, part_pin_number)

func connect_output(part_name: String, part_pin: String, output_pin: String):
	var part = _parts[part_name]
	var output_node = _output_nodes[output_pin]
	output_node.set_child(part, part_pin)
	
func add_part(part_name, part):
	_parts[part_name] = ChipNode.new(part)

func add_input(pin_name, pin_number):
	_input_nodes[pin_name] = InputNode.new(pin_number)

func add_output(pin_name, pin_number):
	_output_nodes[pin_name] = OutputNode.new(pin_number)

func get_input_pin_number(pin_name):
	return _input_nodes[pin_name].input_pin_number

func get_output_pin_number(pin_name):
	return _output_nodes[pin_name].output_pin_number

class ChipNode:
	var _child_nodes = []
	var _chip

	func _init(chip):
		_chip = chip
		
	func evaluate() -> bool:
		var input_values = []
		for child in _child_nodes:
			input_values.append(child.evaluate())
		return _chip.evaluate(input_values)[0]

	func add_child_at(child, i):
		if i >= _child_nodes.size() - 1:
			_child_nodes.resize(i+1)

		_child_nodes[i] = child

	func get_input_pin_number(pin_name) -> int:
		return _chip.get_input_pin_number(pin_name)

	func get_output_pin_number(pin_name) -> int:
		return _chip.get_output_pin_number(pin_name)

class InputNode:
	var _input: Array
	var input_pin_number

	func _init(pin_number):
		input_pin_number = pin_number

	func bind_input(input: Array):
		_input = input

	func evaluate() -> bool:
		if input_pin_number >= _input.size():
			return false
		return _input[input_pin_number]

class OutputNode:
	var output_pin_number: int
	var _chip: ChipNode
	var _chip_output_pin_name: String

	func _init(pin_number: int):
		output_pin_number = pin_number

	func set_child(chip, chip_output_pin: String):
		_chip = chip
		_chip_output_pin_name = chip_output_pin

	func evaluate() -> bool:
		if _chip == null:
			return false
		return _chip.evaluate()
