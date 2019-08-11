extends "res://addons/gut/test.gd"
const Chip = preload("res://tests/chip.gd")

class TrueChip:
	func evaluate(input):
		return true

class NandChip:
	func evaluate(input):
		return !(input[0] and input[1])

var chip = null

func before_each():
	chip = Chip.new()

func test_empty_chip():
	assert_false(chip.evaluate([]))

func test_true_chip():
	chip.add_part("true", TrueChip.new())
	chip.connect_output("true")

	assert_true(chip.evaluate([]))

func test_chip_inputs_are_false_when_not_connected():
	chip.add_part("and", _make_and_chip())
	chip.connect_output("and")

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 0
		0 1 0
		0 0 0
		""")

func test_chip_inputs_are_false_when_not_passed():
	chip.add_part("and", _make_and_chip())
	chip.connect_output("and")

	assert_false(chip.evaluate([]))

func test_nand():
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_part("nand", NandChip.new())
	chip.connect_output("nand")
	chip.connect_part("nand", 0, "a")
	chip.connect_part("nand", 1, "b")
	chip.connect_output("nand")

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 1
		0 1 1
		0 0 1
		""")

func test_not():
	assert_truth_table(_make_not_chip(), 
		"""
		1 0
		0 1
		""")

func test_not_not():
	var not_chip = _make_not_chip()
	chip.add_input("in", 0)
	chip.add_part("not1", not_chip)
	chip.add_part("not2", not_chip)
	chip.connect_output("not2")
	chip.connect_part("not1", 0, "in")
	chip.connect_part("not2", 0, "not1")

	assert_truth_table(chip,
		"""
		1 1
		0 0
		""")

func test_and():
	assert_truth_table(_make_and_chip(),
		"""
		1 1 1
		1 0 0
		0 1 0
		0 0 0
		""")

func test_or_with_constructed_chips():
	_test_or(_make_and_chip())

class NativeAnd:
	func evaluate(input):
		return input[0] && input[1]

func test_or_with_mix_of_native_and_constructed_chips():
	_test_or(NativeAnd.new())

func test_xor():
	var not_chip = _make_not_chip()
	var and_chip = _make_and_chip()
	var or_chip = _make_or_chip(not_chip, and_chip)

	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_part("and", and_chip)
	chip.add_part("or1", or_chip)
	chip.add_part("or2", or_chip)
	chip.add_part("not1", not_chip)
	chip.add_part("not2", not_chip)

	chip.connect_output("and")

	chip.connect_part("and", 0, "or1")
	chip.connect_part("and", 1, "or2")

	chip.connect_part("or1", 0, "a")
	chip.connect_part("or1", 1, "b")
	chip.connect_part("or2", 0, "not1")
	chip.connect_part("or2", 1, "not2")

	chip.connect_part("not1", 0, "a")
	chip.connect_part("not2", 0, "b")

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 1
		0 1 1
		0 0 0
		""")

func _test_or(and_chip):
	var not_chip = _make_not_chip()
	assert_truth_table(_make_or_chip(not_chip, and_chip), 
		"""
		1 1 1
		1 0 1
		0 1 1
		0 0 0
		""")

func _make_not_chip():
	var chip = Chip.new()
	chip.add_input("in", 0)
	chip.add_part("nand", NandChip.new())
	chip.connect_output("nand")
	chip.connect_part("nand", 0, "in")
	chip.connect_part("nand", 1, "in")
	return chip

func _make_and_chip():
	var nand = NandChip.new()
	var chip = Chip.new()
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_part("nand1", nand)
	chip.add_part("nand2", nand)
	chip.connect_output("nand2")
	chip.connect_part("nand1", 0, "a")
	chip.connect_part("nand1", 1, "b")
	chip.connect_part("nand2", 0, "nand1")
	chip.connect_part("nand2", 1, "nand1")

	return chip

func _make_or_chip(not_chip, and_chip):
	var chip = Chip.new()
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_part("not1", not_chip)
	chip.add_part("not2", not_chip)
	chip.add_part("not3", not_chip)
	chip.add_part("and", and_chip)
	chip.connect_output("not3")
	chip.connect_part("not3", 0, "and")
	chip.connect_part("and", 0, "not1")
	chip.connect_part("and", 1, "not2")
	chip.connect_part("not1", 0, "a")
	chip.connect_part("not2", 0, "b")

	return chip

func assert_truth_table(chip, truth_table):
	var no_allow_empty = false
	for line in _clean_lines(truth_table.split("\n", no_allow_empty)):
		var entries = _clean_entries(line.split(" ", no_allow_empty))
		var input = []

		for i in range(entries.size() - 1):
			input.append(entries[i])

		var expected_output = entries[-1]
		assert_eq(chip.evaluate(input), expected_output, "Output does not match truth table")

func _clean_lines(lines):
	var cleaned_lines = []
	for line in lines:
		var clean_line = line.strip_edges(true, true)
		if clean_line != "":
			cleaned_lines.append(clean_line)
	return cleaned_lines

func _clean_entries(entries):
	var cleaned_entries = []
	for entry in entries:
		cleaned_entries.append(entry.strip_edges(true, true) == "1")
	return cleaned_entries

