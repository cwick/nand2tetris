extends "res://addons/gut/test.gd"
const Chip = preload("res://tests/chip.gd")

class NativeChip:
	func get_input_pin_number(pin_name):
		return self.input_pin_map[pin_name]

	func get_output_pin_number(pin_name):
		return self.output_pin_map[pin_name]

class NativeNand extends NativeChip:
	var input_pin_map = {
		a = 0,
		b = 1
	}

	var output_pin_map = {
		out = 0
	}

	func evaluate(input: Array) -> Array:
		return [!(input[0] and input[1])]

class NativeAnd extends NativeChip:
	var input_pin_map = {
		a = 0,
		b = 1
	}

	var output_pin_map = {
		out = 0
	}

	func evaluate(input: Array) -> Array:
		return [input[0] && input[1]]

class TrueChip extends NativeChip:
	var output_pin_map = {
		out = 0
	}

	func evaluate(input):
		return [true]

var chip: Chip = null

func before_each():
	chip = Chip.new()

func test_empty_chip():
	assert_false(chip.evaluate([]))

func test_true_chip():
	chip.add_part("true", TrueChip.new())
	chip.add_output("out", 0)
	chip.connect_output("true", "out", "out")

	assert_true(chip.evaluate([])[0])

func test_chip_inputs_are_false_when_not_connected():
	chip.add_output("out", 0)
	chip.add_input("a", 0)
	chip.add_input("b", 0)
	chip.add_part("and", _make_and_chip())
	chip.connect_output("and", "out", "out")

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 0
		0 1 0
		0 0 0
		""")

func test_chip_outputs_are_false_when_not_connected():
	chip.add_part("and", _make_and_chip())
	chip.add_output("out", 0)
	chip.add_input("a", 0)
	chip.add_input("b", 0)

	chip.connect_input("and", "a", "a")
	chip.connect_input("and", "b", "b")

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 0
		0 1 0
		0 0 0
		""")

func test_chip_inputs_are_false_when_not_passed():
	chip.add_part("and", _make_and_chip())
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
	chip.add_output("out", 0)

	chip.add_part("not1", not_chip)
	chip.add_part("not2", not_chip)
	chip.connect_output("not2", "out", "out")
	chip.connect_input("not1", "in", "in")
	chip.connect_part("not2", "in", "not1")

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

func test_or_with_mix_of_native_and_constructed_chips():
	_test_or(NativeAnd.new())

func test_xor():
	var not_chip = _make_not_chip()
	var and_chip = _make_and_chip()
	var or_chip = _make_or_chip(not_chip, and_chip)

	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_output("out", 0)

	chip.add_part("and", and_chip)
	chip.add_part("or1", or_chip)
	chip.add_part("or2", or_chip)
	chip.add_part("not1", not_chip)
	chip.add_part("not2", not_chip)

	chip.connect_output("and", "out", "out")

	chip.connect_part("and", "a", "or1")
	chip.connect_part("and", "b", "or2")

	chip.connect_part("or2", "a", "not1")
	chip.connect_part("or2", "b", "not2")

	chip.connect_input("not1", "in", "a")
	chip.connect_input("not2", "in", "b")
	chip.connect_input("or1", "a", "a")
	chip.connect_input("or1", "b", "b")

	assert_truth_table(chip, 
		"""
		1 1 0
		1 0 1
		0 1 1
		0 0 0
		""")

func test_mux():
	var not_chip = _make_not_chip()
	var and_chip = _make_and_chip()
	var or_chip = _make_or_chip(not_chip, and_chip)

	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_input("selector", 2)
	chip.add_output("out", 0)

	chip.add_part("or", or_chip)
	chip.add_part("not", not_chip)
	chip.add_part("and1", and_chip)
	chip.add_part("and2", and_chip)

	chip.connect_output("or", "out", "out")

	chip.connect_part("or", "a", "and1")
	chip.connect_part("or", "b", "and2")
	chip.connect_part("and1", "a", "not")

	chip.connect_input("and1", "b", "a")
	chip.connect_input("and2", "a", "b")
	chip.connect_input("and2", "b", "selector")
	chip.connect_input("not", "in", "selector")

	assert_truth_table(chip,
		#  a b selector
		"""
		0 0 0 0
		0 1 0 0
		1 0 0 1
		1 1 0 1

		0 0 1 0
		0 1 1 1
		1 0 1 0
		1 1 1 1
		""")

# func test_dmux():
# 	var not_chip = _make_not_chip()
# 	var and_chip = _make_and_chip()

# 	chip.add_input("in", 0)
# 	chip.add_input("selector", 1)

# 	chip.add_part("and1", and_chip)
# 	chip.add_part("and2", and_chip)
# 	chip.add_part("not", not_chip)

# 	chip.connect_part("and1", 0, "not")
# 	chip.connect_part("and1", 1, "in")
# 	chip.connect_part("and2", 0, "in")
# 	chip.connect_part("and2", 1, "selector")
# 	chip.connect_part("not", 0, "selector")

# 	assert_truth_table(chip,
# 		#  in selector => a b
# 		"""
# 		1 1 0 1 
# 		1 0 1 0
# 		0 1 0 0
# 		0 0 0 0
# 		""")


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
	chip.add_output("out", 0)

	chip.add_part("nand", NativeNand.new())
	chip.connect_output("nand", "out", "out")

	chip.connect_input("nand", "a", "in")
	chip.connect_input("nand", "b", "in")
	return chip

func _make_and_chip():
	var nand = NativeNand.new()
	var chip = Chip.new()
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_output("out", 0)
	chip.add_part("nand1", nand)
	chip.add_part("nand2", nand)

	chip.connect_output("nand2", "out", "out")

	chip.connect_part("nand2", "a", "nand1")
	chip.connect_part("nand2", "b", "nand1")

	chip.connect_input("nand1", "a", "a")
	chip.connect_input("nand1", "b", "b")

	return chip

func _make_or_chip(not_chip, and_chip):
	var chip = Chip.new()
	chip.add_input("a", 0)
	chip.add_input("b", 1)
	chip.add_output("out", 0)

	chip.add_part("not1", not_chip)
	chip.add_part("not2", not_chip)
	chip.add_part("not3", not_chip)
	chip.add_part("and", and_chip)

	chip.connect_output("not3", "out", "out")

	chip.connect_part("not3", "in", "and")
	chip.connect_part("and", "a", "not1")
	chip.connect_part("and", "b", "not2")

	chip.connect_input("not1", "in", "a")
	chip.connect_input("not2", "in", "b")

	return chip

func assert_truth_table(chip, truth_table):
	var no_allow_empty = false
	for line in _clean_lines(truth_table.split("\n", no_allow_empty)):
		var entries = _clean_entries(line.split(" ", no_allow_empty))
		var input = []

		for i in range(entries.size() - 1):
			input.append(entries[i])

		var expected_output = [entries[-1]]
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

