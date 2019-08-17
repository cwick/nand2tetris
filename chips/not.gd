extends "res://chips/simulated_chip.gd"

const Nand = preload("res://chips/native/nand.gd")

func _init():
	self.name = "NOT"
	
	add_input("in", 0)
	add_output("out", 0)

	add_part("nand", Nand.new())
	connect_output("nand", "out", "out")

	connect_input("nand", "a", "in")
	connect_input("nand", "b", "in")