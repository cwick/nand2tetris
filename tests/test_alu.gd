extends "./base_test.gd"
const Alu = preload("res://chips/alu.gd")

var _alu
var _input
var _expected_output

func before_each():
	_alu = Alu.new()
	_input = []
	for i in range(_alu.get_input_pins().size()):
		_input.append(0)
		
	_expected_output = []
	for i in range(_alu.get_output_pins().size()):
		_expected_output.append(0)
	
func test_zero():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("zy", 1)
	_set_input("f", 1)
	
	_set_expected_output("out", 0)
	
	assert_eq(_alu.evaluate(_input), _expected_output)

func test_one():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("nx", 1)
	_set_input("zy", 1)
	_set_input("ny", 1)
	_set_input("f", 1)
	_set_input("no", 1)
	
	_set_expected_output("out", 1)
	
	assert_eq(_alu.evaluate(_input), _expected_output)
	
func test_negative_one():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("nx", 1)
	_set_input("zy", 1)
	_set_input("ny", 0)
	_set_input("f", 1)
	_set_input("no", 0)
	
	_set_expected_output("out", -1 & 255)
	
	_assert_alu()
	
func test_x():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 0)
	_set_input("zy", 1)
	_set_input("ny", 1)
	_set_input("f", 0)
	_set_input("no", 0)
	
	_set_expected_output("out", 12)
	
	_assert_alu()
	
func test_y():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("nx", 1)
	_set_input("zy", 0)
	_set_input("ny", 0)
	_set_input("f", 0)
	_set_input("no", 0)
	
	_set_expected_output("out", 34)
	
	_assert_alu()
	
func test_not_x():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 0)
	_set_input("zy", 1)
	_set_input("ny", 1)
	_set_input("f", 0)
	_set_input("no", 1)
	
	_set_expected_output("out", ~12 & 255)
	
	_assert_alu()
	
func test_not_y():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("nx", 1)
	_set_input("zy", 0)
	_set_input("ny", 0)
	_set_input("f", 0)
	_set_input("no", 1)
	
	_set_expected_output("out", ~34 & 255)
	
	_assert_alu()

func test_negative_x():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 0)
	_set_input("zy", 1)
	_set_input("ny", 1)
	_set_input("f", 1)
	_set_input("no", 1)
	
	_set_expected_output("out", -12 & 255)
	
	_assert_alu()
	
func test_negative_y():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("nx", 1)
	_set_input("zy", 0)
	_set_input("ny", 0)
	_set_input("f", 1)
	_set_input("no", 1)
	
	_set_expected_output("out", -34 & 255)
	
	_assert_alu()
	
func test_x_plus_one():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 1)
	_set_input("zy", 1)
	_set_input("ny", 1)
	_set_input("f", 1)
	_set_input("no", 1)
	
	_set_expected_output("out", 13)
	
	_assert_alu()
	
func test_y_plus_one():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("nx", 1)
	_set_input("zy", 0)
	_set_input("ny", 1)
	_set_input("f", 1)
	_set_input("no", 1)
	
	_set_expected_output("out", 35)
	
	_assert_alu()
	
func test_x_minus_one():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 0)
	_set_input("zy", 1)
	_set_input("ny", 1)
	_set_input("f", 1)
	_set_input("no", 0)
	
	_set_expected_output("out", 11)
	
	_assert_alu()

func test_y_minus_one():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 1)
	_set_input("nx", 1)
	_set_input("zy", 0)
	_set_input("ny", 0)
	_set_input("f", 1)
	_set_input("no", 0)
	
	_set_expected_output("out", 33)
	
	_assert_alu()
	
func test_x_plus_y():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 0)
	_set_input("zy", 0)
	_set_input("ny", 0)
	_set_input("f", 1)
	_set_input("no", 0)
	
	_set_expected_output("out", 12+34)
	
	_assert_alu()
	
func test_x_minus_y():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 1)
	_set_input("zy", 0)
	_set_input("ny", 0)
	_set_input("f", 1)
	_set_input("no", 1)
	
	_set_expected_output("out", 12-34 & 255)
	
	_assert_alu()
	
func test_y_minus_x():
	_set_input("x", 12)
	_set_input("y", 34)
	_set_input("zx", 0)
	_set_input("nx", 0)
	_set_input("zy", 0)
	_set_input("ny", 1)
	_set_input("f", 1)
	_set_input("no", 1)
	
	_set_expected_output("out", 34-12)
	
	_assert_alu()
	
func test_x_and_y():
	_set_input("x", 7)
	_set_input("y", 66)
	_set_input("zx", 0)
	_set_input("nx", 0)
	_set_input("zy", 0)
	_set_input("ny", 0)
	_set_input("f", 0)
	_set_input("no", 0)
	
	_set_expected_output("out", 7 & 66)
	
	_assert_alu()
	
func test_x_or_y():
	_set_input("x", 5)
	_set_input("y", 2)
	_set_input("zx", 0)
	_set_input("nx", 1)
	_set_input("zy", 0)
	_set_input("ny", 1)
	_set_input("f", 0)
	_set_input("no", 1)
	
	_set_expected_output("out", 5 | 2)
	
	_assert_alu()
	
func _set_input(pin_name, value):
	_input[_alu.get_input_pin_number(pin_name)] = value
	
func _set_expected_output(pin_name, value):
	_expected_output[_alu.get_output_pin_number(pin_name)] = value
	
func _assert_alu():
	assert_eq(_alu.evaluate(_input), _expected_output)