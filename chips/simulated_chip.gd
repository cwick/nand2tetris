extends "./chip.gd"

var output_pin_count: int setget ,_get_output_pin_count
var output_pin_map setget ,_get_output_pin_map
var input_pin_map setget ,_get_input_pin_map
var name := "generic chip"

var _parts = {}
var _output_pins = []
var _output_pin_map = {}
var _input_nodes = {}

func evaluate(input):
	for node in _input_nodes.values():
		node.bind_input(input)

	var output = []

	for pin in _output_pins:
		output.append(pin.evaluate() if pin else 0)

	return output

func connect_part(part_name: String, part_input_pin: String,
				  other_part: String, other_part_output_pin: String):
	var other_part_node = _parts[other_part]
	var part = _parts[part_name]
	var connection = InternalPin.new(other_part_node, other_part_output_pin)

	part.add_child_at(connection, part_input_pin)

func connect_input(part_name: String, part_input_pin: String, input_pin: String):
	var part = _parts[part_name]
	var input_node = _input_nodes[input_pin]

	part.add_child_at(input_node, part_input_pin)

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

func _get_output_pin_map():
	return _output_pin_map
	
func _get_input_pin_map():
	var pin_map = {}
	for pin in _input_nodes:
		pin_map[pin] = _input_nodes[pin].input_pin_number

	return pin_map

class InternalPin:
	var _chip_node: ChipNode
	var _output_pin_selector: int

	func _init(chip_node: ChipNode, output_pin_name: String):
		_chip_node = chip_node
		_output_pin_selector = chip_node.get_output_pin_number(output_pin_name)

	func evaluate() -> int:
		var result := _chip_node.evaluate()
		return result[_output_pin_selector]

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

	func add_child_at(child, pin_name: String):
		var pin_number = get_input_pin_number(pin_name)
		if pin_number >= _child_nodes.size() - 1:
			_child_nodes.resize(pin_number + 1)

		_child_nodes[pin_number] = child

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

	func evaluate() -> int:
		if input_pin_number >= _input.size():
			return 0
		return _input[input_pin_number]
