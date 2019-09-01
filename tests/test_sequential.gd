extends "./base_test.gd"
const DataFlipFlop = preload("res://chips/native/flip_flop.gd")
const Mux = preload("res://chips/mux.gd")
const Bit = preload("res://chips/bit.gd")
const Register4 = preload("res://chips/register4.gd")

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
	
