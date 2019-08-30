extends "./chip.gd"

var name := "generic chip"

var _parts = {}
var _output_pins = []
var _output_pin_map = {}
var _input_nodes = {}
var _input_pin_map = {}

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
	var connection = InternalPin.new(other_part_node, other_part_output_pin, 0)

	part.add_child_at(connection, part_input_pin, 0)

func connect_input(part_name: String, part_input_pin: String, input_pin: String, bits = { from = 0, to = 0 }):
	var part = _parts[part_name]
	var input_node = _input_nodes[input_pin + String(bits["from"])]

	part.add_child_at(input_node, part_input_pin, bits["to"])

func connect_output(part_name: String, part_output_pin: String, output_pin: String, bits = { from = 0, to = 0 }):
	var part = _parts[part_name]
	var output_pin_info = _output_pin_map[output_pin]
	var output_pin_node = _output_pins[output_pin_info["pin_number"]]
	if output_pin_node == null:
		output_pin_node = MultiBitPin.new(output_pin_info["bits"])
		
	output_pin_node.add_child_at(InternalPin.new(part, part_output_pin, bits["from"]), bits["to"])
	_output_pins[output_pin_info["pin_number"]] = output_pin_node

func add_part(part_name, part):
	_parts[part_name] = ChipNode.new(part)

func add_input(pin_name, pin_number, bits=1):
	_input_pin_map[pin_name] = { pin_number = pin_number, bits = bits }
	for i in range(bits):
		_input_nodes[pin_name + String(i)] = InputNode.new(pin_number, i)

func add_output(pin_name, pin_number, bits=1):
	if pin_number >= _output_pins.size():
		_output_pins.resize(pin_number + 1)

	_output_pin_map[pin_name] = { pin_number = pin_number, bits = bits }

func get_input_pin_number(pin_name):
	return _input_pin_map[pin_name]["pin_number"]

func get_output_pin_number(pin_name):
	return _output_pin_map[pin_name]["pin_number"]

func get_input_pins():
    var pins = []
    pins.resize(_input_pin_map.size())
    for p in _input_pin_map:
        var pin = _input_pin_map[p]
        pins[pin["pin_number"]] = {
			name = p,
            bits = pin["bits"]
        }
    
    return pins	

func get_output_pins():
	var pins = []
	pins.resize(_output_pin_map.size())
	for p in _output_pin_map:
		var pin = _output_pin_map[p]
		pins[pin["pin_number"]] = {
			name = p,
			bits = pin["bits"]
		}
	
	return pins	

class InternalPin:
	var _chip_node: ChipNode
	var _output_pin_selector: int
	var _bit_number

	func _init(chip_node: ChipNode, output_pin_name: String, bit_number: int):
		_bit_number = bit_number
		_chip_node = chip_node
		_output_pin_selector = chip_node.get_output_pin_number(output_pin_name)

	func evaluate() -> int:
		var result := _chip_node.evaluate()
		return 1 if result[_output_pin_selector] & (1 << _bit_number) else 0

class MultiBitPin:
	var bits := []
	
	func _init(bit_count):
		self.bits.resize(bit_count)
		
	func add_child_at(child, i):
		bits[i] = child
		
	func evaluate() -> int:
		var result := 0
		for i in range(bits.size()):
			var bit = bits[i]
			if bit:
				result |= (bit.evaluate() << i)
		return result
		
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

	func add_child_at(child, pin_name: String, bit_number):
		var pin_number = _chip.get_input_pin_number(pin_name)
		var bit_count = _chip.get_input_pins()[pin_number]["bits"]
		
		if pin_number >= _child_nodes.size() - 1:
			_child_nodes.resize(pin_number + 1)
			
		if not _child_nodes[pin_number]:
			_child_nodes[pin_number] = MultiBitPin.new(bit_count)
		_child_nodes[pin_number].add_child_at(child, bit_number)

	func get_output_pin_number(pin_name) -> int:
		return _chip.get_output_pin_number(pin_name)

class InputNode:
	var _input: Array
	var input_pin_number
	var input_bit_number

	func _init(pin_number, bit_number):
		self.input_pin_number = pin_number
		self.input_bit_number = bit_number

	func bind_input(input: Array):
		_input = input

	func evaluate() -> int:
		if input_pin_number >= _input.size():
			return 0
		return 1 if _input[input_pin_number] & (1 << input_bit_number) else 0
