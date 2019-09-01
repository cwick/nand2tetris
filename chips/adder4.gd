extends "res://chips/simulated_chip.gd"
const FullAdder = preload("./full_adder.gd")

func _init():
	self.name = "Adder4"
	var full_adder = FullAdder.new()
	var bits = 4
	
	add_input("a", 0, bits)
	add_input("b", 1, bits)
	add_output("sum", 0, bits)
	
	for i in range(bits):
		add_part("add%d" % i, full_adder)
	
	for i in range(bits):
		connect_input("add%d" % i, "a", "a", { from = [i, i], to = [0, 0] })
		connect_input("add%d" % i, "b", "b", { from = [i, i], to = [0, 0] })

	for i in range(1, bits):
		connect_part("add%d" % i, "c", "add%d" % (i - 1), "carry")
	
	for i in range(bits):
		connect_output("add%d" % i, "sum", "sum", { from = [0, 0], to = [i, i] })