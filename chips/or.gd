extends "res://chips/simulated_chip.gd"

const Nand = preload("res://chips/native/nand.gd")
const Not = preload("res://chips/not.gd")
const And = preload("res://chips/and.gd")

func _init():
	var not_chip = Not.new()
	var and_chip = And.new()
	self.name = "OR"

	add_input("a", 0)
	add_input("b", 1)
	add_output("out", 0)

	add_part("not1", not_chip)
	add_part("not2", not_chip)
	add_part("not3", not_chip)
	add_part("and", and_chip)

	connect_output("not3", "out", "out")

	connect_part("not3", "in", "and", "out")
	connect_part("and", "a", "not1", "out")
	connect_part("and", "b", "not2", "out")

	connect_input("not1", "in", "a")
	connect_input("not2", "in", "b")