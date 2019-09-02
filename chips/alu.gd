extends "res://chips/simulated_chip.gd"

const Mux = preload("res://chips/native/mux8_2way.gd")
const Not = preload("res://chips/native/not8.gd")
const SimulatedChip = preload("res://chips/simulated_chip.gd")
const Adder8 = preload("res://chips/adder8.gd")


var _bits = 8

func _init():
	self.name = "ALU"

	var mux = Mux.new()
	var not_chip = Not.new()
	var adder = Adder8.new()
	
	add_input("x", 0, _bits)
	add_input("y", 1, _bits)
	add_input("zx", 2)
	add_input("zy", 3)
	add_input("nx", 4)
	add_input("ny", 5)
	add_input("no", 6)
	add_input("f", 7)	
	add_output("out", 0, _bits)
	add_output("zr", 1)
	add_output("ng", 2)

#	add_part("function_select", mux)
	
	var prepare_input = ALUPrepareInput.new(_bits)
	
	# prepare x
	add_part("prepare_x", prepare_input)
	connect_input("prepare_x", "x", "x")
	connect_input("prepare_x", "zx", "zx")
	connect_input("prepare_x", "nx", "nx")
	
	# prepare y
	add_part("prepare_y", prepare_input)
	connect_input("prepare_y", "x", "y")
	connect_input("prepare_y", "zx", "zy")
	connect_input("prepare_y", "nx", "ny")
	connect_output("prepare_y", "out", "out")
	
	# add
	add_part("add", adder)
	connect_part("add", "a", "prepare_x", "out")
	connect_part("add", "b", "prepare_y", "out")
	
	# invert output
	add_part("invert_out", mux)
	add_part("not_out", not_chip)
	connect_output("invert_out", "out", "out")
	connect_part("invert_out", "in0", "add", "sum")
	connect_input("invert_out", "selector", "no")
	connect_part("invert_out", "in1", "not_out", "out")
	connect_part("not_out", "in", "add", "sum")
	
class ALUPrepareInput extends SimulatedChip:
	func _init(bits):
		var mux = Mux.new()
		var not_chip = Not.new()
		
		add_input("x", 0, bits)
		add_input("zx", 1)
		add_input("nx", 2)
		add_output("out", 0, bits)
		
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
