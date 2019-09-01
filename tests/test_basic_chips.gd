extends "./base_test.gd"
const SimulatedChip = preload("res://chips/simulated_chip.gd")
const AndChip = preload("res://chips/and.gd")
const OrChip = preload("res://chips/or.gd")
const XorChip = preload("res://chips/xor.gd")
const MuxChip = preload("res://chips/mux.gd")
const DmuxChip = preload("res://chips/dmux.gd")
const NotChip = preload("res://chips/not.gd")
const Chip = preload("res://chips/chip.gd")
const NativeNand = preload("res://chips/native/nand.gd")
const NativeNand4 = preload("res://chips/native/nand4.gd")

class NativeAnd extends Chip:
	func get_input_pins():
		return [
			{ name = "a", bits = 1},
			{ name = "b", bits = 1},
		]
	
	func get_output_pins():
		return [
			{ name = "out", bits = 1 }
		]
	
	func _evaluate(input: Array) -> Array:
		return [input[0] && input[1]]

class TrueChip extends Chip:
	var output_pin_map = {
		out = { index = 0, bits = 1 }
	}

	func _evaluate(input):
		return [1]

var chip: SimulatedChip = null

func before_each():
	chip = SimulatedChip.new()

func test_empty_chip():
	var result = chip.evaluate([])
	assert_eq(result.size(), 0, "Expected empty result")

func test_true_chip():
	chip.add_part("true", TrueChip.new())
	chip.add_output("out", 0)
	chip.connect_output("true", "out", "out")

	assert_true(chip.evaluate([])[0])

func test_chip_inputs_are_false_when_all_not_connected():
	chip.add_output("out", 0)
	chip.add_input("a", 0)
	chip.add_input("b", 0)
	chip.add_part("and", AndChip.new())
	chip.connect_output("and", "out", "out")

	assert_truth_table(chip, 
		"""
		1 1 = 0
		1 0 = 0
		0 1 = 0
		0 0 = 0
		""")

func test_chip_input_is_false_when_some_not_connected():
	chip.add_output("out", 0)
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_part("and", AndChip.new())
	chip.connect_output("and", "out", "out")
	chip.connect_input("and", "b", "b")

	assert_truth_table(chip, 
		"""
		1 1 = 0
		1 0 = 0
		0 1 = 0
		0 0 = 0
		""")
	
func test_chip_outputs_are_false_when_not_connected():
	chip.add_part("and", AndChip.new())
	chip.add_output("out", 0)
	chip.add_input("a", 0)
	chip.add_input("b", 0)

	chip.connect_input("and", "a", "a")
	chip.connect_input("and", "b", "b")

	assert_truth_table(chip, 
		"""
		1 1 = 0
		1 0 = 0
		0 1 = 0
		0 0 = 0
		""")

func test_chip_inputs_are_false_when_not_passed():
	chip.add_part("and", AndChip.new())
	chip.add_output("out", 0)
	chip.connect_output("and", "out", "out")

	assert_false(chip.evaluate([])[0])

func test_nand():
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_output("out", 0)

	chip.add_part("nand", NativeNand.new())
	chip.connect_output("nand", "out", "out")
	chip.connect_input("nand", "a", "a")
	chip.connect_input("nand", "b", "b")

	assert_truth_table(chip, 
		"""
		1 1 = 0
		1 0 = 1
		0 1 = 1
		0 0 = 1
		""")

func test_not():
	assert_truth_table(NotChip.new(), 
		"""
		1 = 0
		0 = 1
		""")

func test_not_not():
	var not_chip = NotChip.new()
	chip.add_input("in", 0)
	chip.add_output("out", 0)

	chip.add_part("not1", not_chip)
	chip.add_part("not2", not_chip)
	chip.connect_output("not2", "out", "out")
	chip.connect_input("not1", "in", "in")
	chip.connect_part("not2", "in", "not1", "out")

	assert_truth_table(chip,
		"""
		1 = 1
		0 = 0
		""")

func test_bitwise_not_with_two_bits():
	assert_truth_table(_make_bitwise_not_chip(),
		# a b not_a not_b
		"""
		0 0 = 1 1
		0 1 = 1 0
		1 0 = 0 1
		1 1 = 0 0
		""")

func test_chip_with_two_outputs():
	var not_chip = _make_bitwise_not_chip()
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_output("not_a", 0)
	chip.add_output("not_b", 1)

	chip.add_part("not", not_chip)

	chip.connect_output("not", "not_a", "not_a")
	chip.connect_output("not", "not_b", "not_b")
	chip.connect_input("not", "a", "a")
	chip.connect_input("not", "b", "b")

	assert_truth_table(chip,
		# a b not_a not_b
		"""
		0 0 = 1 1
		0 1 = 1 0
		1 0 = 0 1
		1 1 = 0 0
		""")

func test_and():
	assert_truth_table(AndChip.new(),
		"""
		1 1 = 1
		1 0 = 0
		0 1 = 0
		0 0 = 0
		""")

func test_or():
	var not_chip = NotChip.new()
	assert_truth_table(OrChip.new(),
		"""
		1 1 = 1
		1 0 = 1
		0 1 = 1
		0 0 = 0
		""")


func test_xor():
	assert_truth_table(XorChip.new(), 
		"""
		1 1 = 0
		1 0 = 1
		0 1 = 1
		0 0 = 0
		""")

func test_mux():
	assert_truth_table(MuxChip.new(),
		#  a b selector
		"""
		0 0 0 = 0
		0 1 0 = 0
		1 0 0 = 1
		1 1 0 = 1

		0 0 1 = 0
		0 1 1 = 1
		1 0 1 = 0
		1 1 1 = 1
		""")

func test_and_with_three_inputs():
	var and_chip = AndChip.new()
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_input("c", 2)
	chip.add_output("out", 0)

	chip.add_part("and1", and_chip)
	chip.add_part("and2", and_chip)

	chip.connect_input("and1", "a", "a")
	chip.connect_input("and1", "b", "b")
	chip.connect_input("and2", "b", "c")
	chip.connect_part("and2", "a", "and1", "out")
	chip.connect_output("and2", "out", "out")

	assert_truth_table(chip,
		"""
		0 0 0 = 0
		0 1 0 = 0
		1 0 0 = 0
		1 1 0 = 0

		0 0 1 = 0
		0 1 1 = 0
		1 0 1 = 0
		1 1 1 = 1
		""")

func test_connect_chip_with_multiple_outputs():
	var bitwise_not_chip = _make_bitwise_not_chip()
	var not_chip = NotChip.new()
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_output("out", 0)

	chip.add_part("bitwise_not", bitwise_not_chip)
	chip.add_part("not", not_chip)

	chip.connect_input("bitwise_not", "a", "a")
	chip.connect_input("bitwise_not", "b", "b")
	chip.connect_part("not", "in", "bitwise_not", "not_b")

	chip.connect_output("not", "out", "out")

	assert_truth_table(chip,
		# Selects the second bit
		"""
		1 1 = 1
		0 1 = 1
		1 0 = 0
		0 0 = 0
		""")

func test_dmux():
	assert_truth_table(DmuxChip.new(),
		#  in selector => a b
		"""
		1 1 = 0 1 
		1 0 = 1 0
		0 1 = 0 0
		0 0 = 0 0
		""")

func test_multibit_nand():
	chip.add_input("a", 0, 4)
	chip.add_input("b", 1, 4)
	chip.add_output("out", 0, 4)

	chip.add_part("nand", NativeNand4.new())
	for i in range(4):
		chip.connect_output("nand", "out", "out", { from = i, to = i })
	
	for i in range(4):
		chip.connect_input("nand", "a", "a", { from = i, to = i })
	for i in range(4):
		chip.connect_input("nand", "b", "b", { from = i, to = i })

	assert_truth_table(chip,
		"""
		1010 1100 = 0111
		""")

func _make_bitwise_not_chip():
	var not_chip = NotChip.new()
	var chip = SimulatedChip.new()

	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_output("not_a", 0)
	chip.add_output("not_b", 1)

	chip.add_part("not_a", not_chip)
	chip.add_part("not_b", not_chip)
	chip.connect_output("not_a", "out", "not_a")
	chip.connect_output("not_b", "out", "not_b")
	chip.connect_input("not_a", "in", "a")
	chip.connect_input("not_b", "in", "b")

	return chip
