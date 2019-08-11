extends "res://addons/gut/test.gd"
const Chip = preload("res://tests/chip.gd")

class TrueChip:
	var input_pin_count = 0
	func evaluate(input):
		return true

class NandChip:
	var input_pin_count = 2
	func evaluate(input):
		return !(input[0] and input[1])

var chip = null

func before_each():
	chip = Chip.new()

func test_empty_chip():
	assert_false(chip.evaluate([]))

func test_true_chip():
	chip.parts.append(TrueChip.new())
	assert_true(chip.evaluate([]))

func test_nand():
	chip.parts.append(NandChip.new())
	chip.input_pin_count = 2
	chip.connect_part("nand", 0, 0)
	chip.connect_part("nand", 1, 1)

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 1
		0 1 1
		0 0 1
		""")

func test_not():
	chip.parts.append(NandChip.new())
	chip.input_pin_count = 1
	chip.connect_part("nand", 0, 0)
	chip.connect_part("nand", 1, 0)
	assert_truth_table(chip, 
		"""
		1 0
		0 1
		""")

# func test_and():
# 	chip.parts.append(NandChip.new())
# 	chip.parts.append(NandChip.new())
# 	chip.input_pin_count = 2
# 	chip.connect_part("nand1", 0, 0)
# 	chip.connect_part("nand1", 1, 1)
# 	chip.connect_part("nand2", 0, "nand1", 0)
# 	chip.connect_part("nand2", 1, "nand1", 0)
# 	assert_truth_table(chip, 
# 		"""
# 		1 1 1
# 		1 0 0
# 		0 1 0
# 		0 0 0
# 		""")

func assert_truth_table(chip, truth_table):
	var no_allow_empty = false
	for line in truth_table.split("\n", no_allow_empty):
		var entries = line.split(" ", no_allow_empty)
		var input = []

		for i in range(entries.size() - 1):
			input.append(entries[i].strip_edges(true, true) == "1")

		if input.size() > 0:
			var expected_output = entries[-1] == "1"
			assert_eq(chip.evaluate(input), expected_output, "Output does not match truth table")