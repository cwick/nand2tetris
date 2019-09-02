extends "res://chips/simulated_chip.gd"

const Nand = preload("res://chips/native/nand.gd")

func _init():
	self.name = "XOR"

	var nand = Nand.new()

	add_input("a", 0)
	add_input("b", 1)
	add_output("out", 0)

	add_part("nand1", nand)
	add_part("nand2", nand)
	add_part("nand3", nand)
	add_part("nand4", nand)
	
	connect_output("nand1", "out", "out")

	connect_part("nand1", "a", "nand2", "out")
	connect_part("nand1", "b", "nand3", "out")
	connect_part("nand2", "b", "nand4", "out")
	connect_part("nand3", "a", "nand4", "out")

	connect_input("nand2", "a", "a")
	connect_input("nand3", "b", "b")
	connect_input("nand4", "a", "a")
	connect_input("nand4", "b", "b")