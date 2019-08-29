extends "res://chips/simulated_chip.gd"
const And = preload("res://chips/and.gd")
const Xor = preload("res://chips/xor.gd")

func _init():
	self.name = "HalfAdder"
	
	add_input("a", 0)
	add_input("b", 1)
	add_output("carry", 0)
	add_output("sum", 1)
	
	add_part("xor", Xor.new())
	add_part("and", And.new())
		
	connect_input("xor", "a", "a")
	connect_input("xor", "b", "b")
		
	connect_input("and", "a", "a")
	connect_input("and", "b", "b")
		
	connect_output("xor", "out", "sum")
	connect_output("and", "out", "carry")