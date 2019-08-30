extends "res://chips/simulated_chip.gd"
const HalfAdder = preload("./half_adder.gd")
const Or = preload("./or.gd")

func _init():
	self.name = "FullAdder"
	
	add_input("a", 0)
	add_input("b", 1)
	add_input("c", 2)
	add_output("carry", 0)
	add_output("sum", 1)
	
	add_part("hadd1", HalfAdder.new())
	add_part("hadd2", HalfAdder.new())
	add_part("or", Or.new())
		
	connect_input("hadd1", "a", "a")
	connect_input("hadd1", "b", "b")		
	connect_input("hadd2", "b", "c")
	
	connect_part("hadd2", "a", "hadd1", "sum")
	connect_part("or", "a", "hadd1", "carry")
	connect_part("or", "b", "hadd2", "carry")
		
	connect_output("or", "out", "carry")
	connect_output("hadd2", "sum", "sum")