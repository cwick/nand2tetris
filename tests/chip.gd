var _parts = {}
var _output_pins = []
var _output_pin_map = {}
var _input_nodes = {}

var output_pin_count setget ,_get_output_pin_count

func evaluate(input):
	for node in _input_nodes.values():
		node.bind_input(input)

	var output = []

	for pin in _output_pins:
		output.append(pin.evaluate() if pin else false)

	return output

func connect_part(part_name: String, part_pin: String, other_part: String):
	var other_part_node = _parts[other_part]
	var part = _parts[part_name]
	var part_pin_number = part.get_input_pin_number(part_pin)
	var connection = InternalPin.new(other_part_node, "todo_implement_me")

	part.add_child_at(connection, part_pin_number)

func connect_input(part_name: String, part_input_pin: String, input_pin: String):
	var part = _parts[part_name]
	var input_node = _input_nodes[input_pin]
	var part_pin_number = part.get_input_pin_number(part_input_pin)

	part.add_child_at(input_node, part_pin_number)

func connect_output(part_name: String, part_output_pin: String, output_pin: String):
	var part = _parts[part_name]
	_output_pins[_output_pin_map[output_pin]] = InternalPin.new(part, part_output_pin)
	
func add_part(part_name, part):
	_parts[part_name] = ChipNode.new(part)

func add_input(pin_name, pin_number):
	_input_nodes[pin_name] = InputNode.new(pin_number)

func add_output(pin_name, pin_number):
	if pin_number >= _output_pins.size():
		_output_pins.resize(pin_number + 1)

	_output_pin_map[pin_name] = pin_number

func get_input_pin_number(pin_name):
	return _input_nodes[pin_name].input_pin_number

func get_output_pin_number(pin_name):
	return _output_pin_map[pin_name]

func _get_output_pin_count():
	return _output_pins.size()

class InternalPin:
	var _chip_node: ChipNode
	var _output_pin_selector: int

	func _init(chip_node: ChipNode, output_pin_name: String):
		_chip_node = chip_node
		if output_pin_name == "todo_implement_me":
			_output_pin_selector = 0
		else:
			_output_pin_selector = chip_node.get_output_pin_number(output_pin_name)

	func evaluate() -> bool:
		var result := _chip_node.evaluate()
		return result[_output_pin_selector] as bool

class ChipNode:
	var _child_nodes = []
	var _chip

	func _init(chip):
		_chip = chip
		
	func evaluate() -> Array:
		var input_values = []
		for child in _child_nodes:
			input_values.append(child.evaluate())
		return _chip.evaluate(input_values)

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
