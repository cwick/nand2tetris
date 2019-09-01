extends "res://chips/simulated_chip.gd"
const Bit = preload("res://chips/bit.gd")

func _init():
	self.name = "Register4"
	var bits = 4
			
	add_input("load", 0)
	add_input("in", 1, bits)
	add_output("out", 0, bits)
	
	for i in range(bits):
		add_part("bit%d" % i, Bit.new())
		connect_output("bit%d" % i, "out", "out", { from = 0, to = i})
		connect_input("bit%d" % i, "in", "in", { from = i, to = 0})
		connect_input("bit%d" % i, "load", "load")
