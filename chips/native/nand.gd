extends "./chip.gd"

var input_pin_map = {
    a = 0,
    b = 1
}

var output_pin_map = {
    out = 0
}

var name = "NAND"

func evaluate(input: Array) -> Array:
    return [!(input[0] and input[1])]