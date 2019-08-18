extends "res://chips/simulated_chip.gd"
const Not = preload("res://chips/not.gd")
const And = preload("res://chips/and.gd")
const Or = preload("res://chips/or.gd")

func _init():
	var not_chip = Not.new()
	var and_chip = And.new()
	var or_chip = Or.new()

	self.name = "MUX"

	add_input("a", 0)
	add_input("b", 1)
	add_input("selector", 2)
	add_output("out", 0)

	add_part("or", or_chip)
	add_part("not", not_chip)
	add_part("and1", and_chip)
	add_part("and2", and_chip)

	connect_output("or", "out", "out")

	connect_part("or", "a", "and1", "out")
	connect_part("or", "b", "and2", "out")
	connect_part("and1", "a", "not", "out")

	connect_input("and1", "b", "a")
	connect_input("and2", "a", "b")
	connect_input("and2", "b", "selector")
	connect_input("not", "in", "selector")
