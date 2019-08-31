extends "res://addons/gut/test.gd"

func assert_truth_table(chip, truth_table):
	var no_allow_empty = false
	for line in _clean_lines(truth_table.split("\n", no_allow_empty)):
		var entries = _clean_entries(line.split(" ", no_allow_empty))
		var input = []
		var expected_output = []
		var a = input

		for i in range(entries.size()):
			var entry = entries[i]
			if entry == "=":
				a = expected_output
			else:
				a.append(_parse_binary_integer(entry))

		assert_eq(chip.evaluate(input), expected_output, "Output does not match truth table: " + line)

func _clean_lines(lines):
	var cleaned_lines = []
	for line in lines:
		var cleaned_line = line.strip_edges(true, true)
		if cleaned_line != "":
			cleaned_lines.append(cleaned_line)
	return cleaned_lines

func _clean_entries(entries):
	var cleaned_entries = []
	for entry in entries:
		cleaned_entries.append(entry.strip_edges(true, true))
	return cleaned_entries

func _parse_binary_integer(binary_string: String) -> int:
	var result := 0
	for i in range(binary_string.length()):
		var bit := (binary_string[binary_string.length() - i - 1] == "1") as int
		result |= (bit << i)

	return result

