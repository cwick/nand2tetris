extends "../chip.gd"

func get_input_pins():
    return [
        { name = "a", bits = 4},
        { name = "b", bits = 4},
    ]

func get_output_pins():
    return [
        { name = "out", bits = 4 }
    ]

var name = "NAND4"

func evaluate(input: Array) -> Array:
    return [0xF & ~(input[0] & input[1])]