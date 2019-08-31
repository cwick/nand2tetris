extends "./base_test.gd"
const DataFlipFlop = preload("res://chips/native/flip_flop.gd")

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
	
	
