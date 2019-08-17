extends "res://chips/simulated_chip.gd"

const Or = preload("res://chips/or.gd")
const Not = preload("res://chips/not.gd")
const And = preload("res://chips/and.gd")

func _init():
	self.name = "XOR"

	var not_chip = Not.new()
	var and_chip = And.new()
	var or_chip = Or.new()

	add_input("a", 0)
	add_input("b", 1)
	add_output("out", 0)

	add_part("and", and_chip)
	add_part("or1", or_chip)
	add_part("or2", or_chip)
	add_part("not1", not_chip)
	add_part("not2", not_chip)

	connect_output("and", "out", "out")

	connect_part("and", "a", "or1", "out")
	connect_part("and", "b", "or2", "out")

	connect_part("or2", "a", "not1", "out")
	connect_part("or2", "b", "not2", "out")

	connect_input("not1", "in", "a")
	connect_input("not2", "in", "b")
	connect_input("or1", "a", "a")
	connect_input("or1", "b", "b")