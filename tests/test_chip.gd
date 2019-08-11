extends "res://addons/gut/test.gd"
const Chip = preload("res://tests/chip.gd")

class TrueChip:
	func evaluate(input):
		return true

class AndChip:
	func evaluate(input):
		return input[0] and input[1]

func test_empty_chip():
	var chip = Chip.new()
	assert_false(chip.evaluate())

func test_true_chip():
	var chip = Chip.new()
	chip.implementation = TrueChip.new()
	assert_true(chip.evaluate())

func test_and_true_true():
	var chip = Chip.new()
	chip.implementation = AndChip.new()
	assert_true(chip.evaluate([true, true]))

func test_and_true_false():
	var chip = Chip.new()
	chip.implementation = AndChip.new()
	assert_false(chip.evaluate([true, false]))

