extends "../chip.gd"

var size = 8
var _output = []

func _init():
	_output.resize(size)
	
func get_input_pins():
	return [
		{ name = "in", bits = 4 },
		{ name = "selector", bits = log(size) / log(2) }
	]

func get_output_pins():
	var pins = []
	for i in range(size):
		pins.append({ name = "out%d" % i, bits = 4 })
	return pins

var name = "DMUX8"

func _evaluate(input: Array) -> Array:
	var value = input[0]
	var selector = input[1]
	
	for i in range(_output.size()):
		_output[i] = value if i == selector else 0
		
	return _output