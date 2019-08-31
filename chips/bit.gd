extends "res://chips/simulated_chip.gd"
const DataFlipFlop = preload("res://chips/native/flip_flop.gd")
const Mux = preload("res://chips/mux.gd")

func _init():
	self.name = "Bit"
			
	add_input("load", 0)
	add_input("in", 1)
	add_output("out", 0)
	
	add_part("mux", Mux.new())
	add_part("dff", DataFlipFlop.new())
	
	connect_input("mux", "b", "in")
	connect_input("mux", "selector", "load")
	connect_part("dff", "in", "mux", "out")
	# Feedback loop between flip-flop and mux
	connect_part("mux", "a", "dff", "out")
	
	connect_output("dff", "out", "out")
