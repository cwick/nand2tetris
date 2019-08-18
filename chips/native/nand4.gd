extends "./chip.gd"

var input_pin_map = {
    a = 0,
    b = 1
}

var output_pin_map = {
    out = 0
}

var name = "NAND4"

func evaluate(input: Array) -> Array:
    return [0xF & ~(input[0] & input[1])]