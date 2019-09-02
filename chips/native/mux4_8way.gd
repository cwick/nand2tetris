extends "../chip.gd"

var size = 8
func get_input_pins():
	var pins = []
	
	for i in range(size):
		pins.append({ name = "in%d" % i, bits = 4})
		
	pins.append({ name = "selector", bits = log(size) / log(2) })
	
	return pins		

func get_output_pins():
    return [
        { name = "out", bits = 4 }
    ]

var name = "MUX4_8Way"

func _evaluate(input: Array) -> Array:
    return [input[input[size]]]