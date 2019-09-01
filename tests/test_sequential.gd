extends "./base_test.gd"
const DataFlipFlop = preload("res://chips/native/flip_flop.gd")
const Mux = preload("res://chips/mux.gd")
const Bit = preload("res://chips/bit.gd")
const Register4 = preload("res://chips/register4.gd")
const Ram8 = preload("res://chips/ram8.gd")

func test_data_flip_flop():
	var flip_flop = DataFlipFlop.new()
	assert_eq(flip_flop.evaluate([0]), [0])
	assert_eq(flip_flop.evaluate([1]), [0])
	
	flip_flop.tick()
	
	# Flip flop remembers value from last tick
	assert_eq(flip_flop.evaluate([0]), [1])
	assert_eq(flip_flop.evaluate([1]), [1])
	
	flip_flop.tick()
	
	assert_eq(flip_flop.evaluate([0]), [1])
	flip_flop.tick()
	assert_eq(flip_flop.evaluate([0]), [0])
	
func test_data_flip_flop_empty_input():
	var flip_flop = DataFlipFlop.new()
	flip_flop.evaluate([1])
	
	flip_flop.tick()
	assert_eq(flip_flop.evaluate([]), [1])
	flip_flop.tick()
	assert_eq(flip_flop.evaluate([]), [1])
	
func test_bit():
	var bit = Bit.new()

	assert_eq(_read_word(bit), 0)
	assert_eq(_set_word(bit, 1), 0)
	bit.tick()
	assert_eq(_read_word(bit), 1, "bit failed to remember value")
	bit.tick()
	assert_eq(_read_word(bit), 1, "bit failed to remember value for two ticks")

func test_register():
	var register = Register4.new()

	assert_eq(_read_word(register), 0)
	assert_eq(_set_word(register, 5), 0)
	register.tick()
	assert_eq(_read_word(register), 5, "register failed to remember value")
	register.tick()
	assert_eq(_read_word(register), 5, "register failed to remember value for two ticks")
		
func _set_word(register, value):
	return register.evaluate([1, value])[0]
	
func _read_word(register):
	return register.evaluate([0, 0])[0]
	
func test_ram8():
	var ram = Ram8.new()
	var input_pins = ram.get_input_pins()
	var address_bits = input_pins[ram.get_input_pin_number("address")]["bits"]
	var ram_size = pow(2, address_bits)
	var input = []
	input.resize(input_pins.size())
	
	# Write value into every register
	for i in range(ram_size):
		input[ram.get_input_pin_number("load")] = 1
		input[ram.get_input_pin_number("address")] = i
		input[ram.get_input_pin_number("in")] = i
		
		ram.evaluate(input)
		ram.tick()
	
	# Read value from every register
	for i in range(ram_size):
		input[ram.get_input_pin_number("load")] = 0
		input[ram.get_input_pin_number("address")] = i
		input[ram.get_input_pin_number("in")] = 0
		
		assert_eq(ram.evaluate(input), [i])
	
