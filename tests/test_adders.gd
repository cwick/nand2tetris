extends "./base_test.gd"
const HalfAdder = preload("res://chips/half_adder.gd")
const FullAdder = preload("res://chips/full_adder.gd")
const Adder4 = preload("res://chips/adder4.gd")

func test_half_adder():
	var adder = HalfAdder.new()
	
	assert_truth_table(adder,
		"""
		0 0 = 0 0
		0 1 = 0 1
		1 0 = 0 1
		1 1 = 1 0
		""")

func test_full_adder():
	var adder = FullAdder.new()
	
	assert_truth_table(adder,
		"""
		0 0 0 = 0 0
		0 0 1 = 0 1
		0 1 0 = 0 1
		0 1 1 = 1 0
		1 0 0 = 0 1
		1 0 1 = 1 0
		1 1 0 = 1 0
		1 1 1 = 1 1
		""")
	
func test_4_bit_adder():
	var adder = Adder4.new()
	var max_value = pow(2, 4)
	var truth_table = ""
	
	for a in range(max_value):
		for b in range(max_value):
			truth_table += "%s %s = %s\n" % [_to_binary_string(a), 
			_to_binary_string(b), _to_binary_string(a+b)]
			
	assert_truth_table(adder, truth_table)
		
func _to_binary_string(value: int):
	var string_value = "0000"
	for i in range(string_value.length()):
		string_value[string_value.length() - i - 1] = "1" if bool(value & (1 << i)) else "0"
		
	return string_value