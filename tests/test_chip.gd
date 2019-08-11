extends "res://addons/gut/test.gd"
const Chip = preload("res://tests/chip.gd")

class TrueChip:
	func evaluate(input):
		return true

class AndChip:
	func evaluate(input):
		return input[0] and input[1]

class NandChip:
	func evaluate(input):
		return !(input[0] and input[1])

var chip = null

func before_each():
	chip = Chip.new()

func test_empty_chip():
	assert_false(chip.evaluate([]))

func test_true_chip():
	chip.implementations.append(TrueChip.new())
	assert_true(chip.evaluate([]))

func test_and_with_two_inputs():
	chip.implementations.append(AndChip.new())
	assert_truth_table(chip, 
		"""
		1 1 1
		1 0 0
		0 1 0
		0 0 0
		""")

func test_and_with_three_inputs():
	chip.implementations.append(AndChip.new())
	chip.implementations.append(AndChip.new())
	assert_truth_table(chip, 
		"""
		1 1 1 1
		1 1 0 0
		1 0 1 0
		1 0 0 0
		0 1 1 0
		0 1 0 0
		0 0 1 0
		0 0 0 0
		""")

func test_nand():
	chip.implementations.append(NandChip.new())

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 1
		0 1 1
		0 0 1
		""")

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