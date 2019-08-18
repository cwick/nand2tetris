extends "./chip.gd"

var input_pin_map = {
    a = { index = 0, bits = 1 },
    b = { index = 1, bits = 1 }
}

var output_pin_map = {
    out = { index = 0, bits = 1 }
}

var name = "NAND"

func evaluate(input: Array) -> Array:
    var result = !(input[0] and input[1])
    return [result as int]