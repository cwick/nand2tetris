extends "../chip.gd"

var name = "FlipFlop"
var _previous_input := 0
var _current_input := 0

func get_input_pins():
    return [
        { name = "in", bits = 1},
    ]

func get_output_pins():
    return [
        { name = "out", bits = 1 }
    ]

func _evaluate(input):
	if input.size() > 0:
		_current_input = input[0]
	return [_previous_input]

func tick():
	_previous_input = _current_input

	