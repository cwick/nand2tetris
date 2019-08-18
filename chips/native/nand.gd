extends "../chip.gd"

func get_input_pins():
    return [
        { name = "a", bits = 1},
        { name = "b", bits = 1},
    ]

func get_output_pins():
    return [
        { name = "out", bits = 1 }
    ]

var name = "NAND"

func evaluate(input: Array) -> Array:
    var result = !(input[0] and input[1])
    return [result as int]