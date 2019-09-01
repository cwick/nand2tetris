extends "./chip.gd"

var name := "generic chip"

var _parts = {}
var _output_pins = []
var _output_pin_map = {}
var _input_pins = []
var _input_pin_map = {}

func _evaluate(input):
	for pin in _input_pins:
		pin.bind_input(input)

	var output = []

	for pin in _output_pins:
		output.append(pin.evaluate())

	return output

func _invalidate():
	for p in _parts:
		_parts[p]._invalidate()

func connect_part(part_name: String, part_input_pin: String,
				  other_part: String, other_part_output_pin: String):
	var other_part_node = _parts[other_part]
	var part = _parts[part_name]
	var connection = ChipSource.new(other_part_node, other_part_output_pin, [0, 15])
	var part_input_pin_bits = part.get_input_pin(part_input_pin)["bits"]
	
	part.add_word_to_pin(connection, part_input_pin, [0, part_input_pin_bits - 1])
	
func connect_input(part_name: String, part_input_pin: String, input_pin: String, bit_mapping = null):
	var part = _parts[part_name]
	var input_pin_number = get_input_pin_number(input_pin)
	var bit_count = _input_pin_map[input_pin]["bits"]
	
	if not bit_mapping:
		bit_mapping = { from = [0, bit_count - 1], to = [0, bit_count -1] }
	
	var word_source = InputPin.new(input_pin_number, bit_mapping["from"])
	_input_pins.append(word_source)
	
	part.add_word_to_pin(word_source, part_input_pin, bit_mapping["to"])

func connect_output(part_name: String, part_output_pin: String, output_pin: String, bit_mapping = null):
	var part = _parts[part_name]
	var output_pin_number = get_output_pin_number(output_pin)
	var bit_count = _output_pin_map[output_pin]["bits"]
	
	if not bit_mapping:
		bit_mapping = { from = [0, bit_count - 1], to = [0, bit_count -1] }
		
	var source = ChipSource.new(part, part_output_pin, bit_mapping["from"])
	
	# If we're mapping onto the full width of the output pin, we can connect the 
	# source directly to the pin, eliminating the use of an internal pin
	if bit_mapping["to"] == [0, bit_count - 1]:
		_output_pins[output_pin_number] = source
	else:
		_output_pins[output_pin_number].add_word(bit_mapping["to"], source) 
			
func add_part(part_name, part):
	_parts[part_name] = ChipNode.new(part)

func add_input(pin_name, pin_number, bits=1):
	_input_pin_map[pin_name] = { pin_number = pin_number, bits = bits }

func add_output(pin_name, pin_number, bits=1):
	_output_pin_map[pin_name] = { pin_number = pin_number, bits = bits }
	
	if pin_number >= _output_pins.size():
		_output_pins.resize(pin_number + 1)
		_output_pins[pin_number] = InternalPin.new()

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

func tick():
	# TODO: fix horribly inefficient tree walk to find all the chips that need a tick
	for p in _parts:
		_parts[p].tick()
				

class ChipNode:
	var _pins := []
	var _chip
	var _cached_value
	var _is_feedback_loop = false

	func _init(chip):
		_chip = chip
		
	func evaluate() -> Array:
		var should_evaluate_children = not _is_feedback_loop			
		_is_feedback_loop = true
		
		if not _cached_value:
			var input_values = []
			if should_evaluate_children:
				for pin in _pins:
					input_values.append(pin.evaluate() if pin else 0)
			
			_chip._invalidate()
			_cached_value = _chip._evaluate(input_values)
						
		if should_evaluate_children:
			_is_feedback_loop = false
		
		return _cached_value

	func _invalidate():
		_cached_value = null
		
	func add_word_to_pin(word_source, pin_name, bit_range):
		var pin_number = _chip.get_input_pin_number(pin_name)
		if pin_number >= _pins.size() - 1:
			_pins.resize(pin_number + 1)
			
		# If we're mapping onto the full width of the pin, we can connect the 
		# source directly to the pin, eliminating the use of an internal pin
		if bit_range == [0, get_input_pin(pin_name)["bits"] - 1]:
			_pins[pin_number] = word_source
		else:
			var pin = _pins[pin_number]
			if not pin:
				pin = InternalPin.new()
				_pins[pin_number] = pin
				
			pin.add_word(bit_range, word_source)
			
	func get_output_pin_number(pin_name) -> int:
		return _chip.get_output_pin_number(pin_name)
		
	func get_input_pin_number(pin_name) -> int:
		return _chip.get_input_pin_number(pin_name)

	func get_input_pin(pin_name):
		return _chip.get_input_pins()[get_input_pin_number(pin_name)]
		
	func tick():				
		_chip.tick()
		

class ChipSource:
	var _chip_node: ChipNode
	var _output_pin_selector: int
	var _bit_range: Array
	var _bit_mask: int

	func _init(chip_node: ChipNode, output_pin_name: String, bit_range: Array):
		_bit_range = bit_range
		_chip_node = chip_node
		_output_pin_selector = chip_node.get_output_pin_number(output_pin_name)
		
		_bit_mask = 0
		
		for i in range(bit_range[0], bit_range[1] + 1):
			_bit_mask |= 1 << i

	func evaluate() -> int:
		var result = _chip_node.evaluate()[_output_pin_selector]
		return (result & _bit_mask) >> _bit_range[0]

		
class InputPin:
	var _pin_number: int
	var _bit_range: Array
	var _input: Array
	var _bit_mask: int
	
	func _init(pin_number, bit_range):
		_pin_number = pin_number
		_bit_range = bit_range
		_bit_mask = 0
		
		for i in range(bit_range[0], bit_range[1] + 1):
			_bit_mask |= 1 << i
		
	func bind_input(input: Array):
		_input = input
		
	func evaluate() -> int:
		if _pin_number >= _input.size():
			return 0
		
		return (_input[_pin_number] & _bit_mask) >> _bit_range[0]
		
class InternalPin:
	var _words = []
	
	func evaluate() -> int:
		var result = 0
		for w in _words:
			var word_value: int = w["source"].evaluate()
			result |= word_value << w["range"][0]
			
		return result
	
	func add_word(bit_range, word_source):
		# TODO: sort words by range
		_words.append({
			range = bit_range, source = word_source
		})