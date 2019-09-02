extends "res://chips/simulated_chip.gd"

const Mux = preload("res://chips/native/mux8_2way.gd")
const Not = preload("res://chips/native/not8.gd")

func _init():
	self.name = "ALU"
	var bits = 8
	var mux = Mux.new()
	var not_chip = Not.new()
	
	add_input("x", 0, bits)
	add_input("y", 1, bits)
	add_input("zx", 2)
	add_input("zy", 3)
	add_input("nx", 4)
	add_input("ny", 5)
	add_input("no", 6)
	add_input("f", 7)	
	add_output("out", 0, bits)
	add_output("zr", 1)
	add_output("ng", 2)

	add_part("function_select", mux)
	

	
	# zero x
	add_part("zero_x", mux)
	connect_input("zero_x", "in0", "x")
	connect_input("zero_x", "selector", "zx")


	# invert x
	add_part("invert_x", mux)
	add_part("not_x", not_chip)
	connect_part("invert_x", "in0", "zero_x", "out")
	connect_part("invert_x", "in1", "not_x", "out")
	connect_input("invert_x", "selector", "nx")
	connect_part("not_x", "in", "zero_x", "out")
	
	connect_output("invert_x", "out", "out")