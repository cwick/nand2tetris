extends "res://chips/simulated_chip.gd"
const FullAdder = preload("./full_adder.gd")

func _init():
	self.name = "Adder4"
	var full_adder = FullAdder.new()
	
	add_input("a", 0, 2)
	add_input("b", 1, 2)
	add_output("sum", 0, 2)
	
	add_part("add0", full_adder)
	add_part("add1", full_adder)
	
	connect_input("add0", "a", "a", { from = 0, to = 0 })
	connect_input("add0", "b", "b", { from = 0, to = 0 }) 
	#connect_input("add1", "a", "a", 1)
	#connect_input("add1", "b", "b", 1)
	
	#connect_part("add1", "c", "add0", "carry")
	
	#connect_output("add0", "sum", "sum", 0)
	#connect_output("add1", "sum", "sum", 1)