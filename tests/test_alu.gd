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
		
	input[alu.get_input_pin_number("x")] = 12
	input[alu.get_input_pin_number("y")] = 34
	input[alu.get_input_pin_number("zx")] = 1
	input[alu.get_input_pin_number("zy")] = 1
	input[alu.get_input_pin_number("f")] = 1
	
	assert_eq(alu.evaluate(input), expected_output)

func test_one():
	var alu = Alu.new()
	var input = []
	for i in range(alu.get_input_pins().size()):
		input.append(0)
		
	var expected_output = []
	for i in range(alu.get_output_pins().size()):
		expected_output.append(0)
	
	expected_output[alu.get_output_pin_number("out")] = 1
		
	input[alu.get_input_pin_number("zx")] = 1
	input[alu.get_input_pin_number("nx")] = 1
	input[alu.get_input_pin_number("zy")] = 1
	input[alu.get_input_pin_number("ny")] = 1
	input[alu.get_input_pin_number("f")] = 1
	input[alu.get_input_pin_number("no")] = 1
	
	assert_eq(alu.evaluate(input), expected_output)