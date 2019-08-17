extends "res://chips/simulated_chip.gd"

const Nand = preload("res://chips/native/nand.gd")

func _init():
	var nand = Nand.new()
	self.name = "AND"
    
	add_input("a", 0)
	add_input("b", 1)
	add_output("out", 0)
	add_part("nand1", nand)
	add_part("nand2", nand)

	connect_output("nand2", "out", "out")

	connect_part("nand2", "a", "nand1", "out")
	connect_part("nand2", "b", "nand1", "out")

	connect_input("nand1", "a", "a")
	connect_input("nand1", "b", "b")
	