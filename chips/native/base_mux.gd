extends "../chip.gd"

func get_input_pins():
	var pins = []
	
	for i in range(self.size):
		pins.append({ name = "in%d" % i, bits = self.bits})
		
	pins.append({ name = "selector", bits = log(self.size) / log(2) })
	
	return pins		

func get_output_pins():
    return [
        { name = "out", bits = self.bits }
    ]

var name: String setget , _get_name

func _get_name():
	return "MUX%d_%dWay" % [self.bits, self.size]
	
func _evaluate(input: Array) -> Array:
    return [input[input[self.size]]]