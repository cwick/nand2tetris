extends "./base_test.gd"
const Alu = preload("res://chips/alu.gd")

func test_zero():
	var alu = Alu.new()
	var input = []
	for i in range(alu.get_input_pins().size()):
		input.append(0)
		
	var expected_output = []
	for i in range(alu.get_output_pins().size()):
		expected_output.append(0)
		
	input[alu.get_input_pin_number("zx")] = 1
	input[alu.get_input_pin_number("zy")] = 1
	input[alu.get_input_pin_number("f")] = 1
	
	assert_eq(alu.evaluate(input), expected_output)
