extends "../chip.gd"

func get_input_pins():
    return [
        { name = "a", bits = 8},
        { name = "b", bits = 8},
    ]

func get_output_pins():
    return [
        { name = "out", bits = 8 }
    ]

var name = "AND8"

func _evaluate(input: Array) -> Array:
    return [input[0] & input[1]]