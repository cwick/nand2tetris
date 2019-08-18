extends "res://chips/simulated_chip.gd"
const Not = preload("res://chips/not.gd")
const And = preload("res://chips/and.gd")

func _init():
	self.name = "DMUX"

	var not_chip = Not.new()
	var and_chip = And.new()

	add_input("in", 0)
	add_input("selector", 1)
	add_output("a", 0)
	add_output("b", 1)

	add_part("and1", and_chip)
	add_part("and2", and_chip)
	add_part("not", not_chip)

	connect_part("and1", "a", "not", "out")
	connect_input("and1", "b", "in")
	connect_input("and2", "a", "in")
	connect_input("and2", "b", "selector")
	connect_input("not", "in", "selector")
	connect_output("and1", "out", "a")
	connect_output("and2", "out", "b")
