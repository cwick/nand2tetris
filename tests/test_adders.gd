extends "./base_test.gd"
const HalfAdder = preload("res://chips/half_adder.gd")

func test_half_adder():
	var adder = HalfAdder.new()
	
	assert_truth_table(adder,
		"""
		0 0 = 0 0
		0 1 = 0 1
		1 0 = 0 1
		1 1 = 1 0
		""")
	