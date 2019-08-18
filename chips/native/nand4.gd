extends "./chip.gd"

var input_pin_map = {
    a = { index = 0, bits = 4 },
    b = { index = 1, bits = 4 }
}

var output_pin_map = {
    out = { index = 0, bits = 4 }
}

var name = "NAND4"

func evaluate(input: Array) -> Array:
    return [0xF & ~(input[0] & input[1])]