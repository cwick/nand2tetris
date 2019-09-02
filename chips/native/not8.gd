extends "../chip.gd"

func get_input_pins():
    return [
        { name = "in", bits = 8},
    ]

func get_output_pins():
    return [
        { name = "out", bits = 8 }
    ]

var name = "NOT8"

func _evaluate(input: Array) -> Array:
    return [~input[0]]