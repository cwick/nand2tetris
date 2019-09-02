extends "res://chips/simulated_chip.gd"
const Register4 = preload("res://chips/register4.gd")
const Mux4_8Way = preload("res://chips/native/mux4_8way.gd")
const Dmux4_8Way = preload("res://chips/native/dmux4_8way.gd")

func _init():
	self.name = "RAM8"
	var size = 8
	var bits = 4
	var address_bits = log(size) / log(2)
			
	add_input("load", 0)
	add_input("in", 1, bits)
	add_input("address", 2, address_bits)
	add_output("out", 0, bits)
	
	# Bank of memory registers
	for i in range(size):
		add_part("register%d" % i, Register4.new())
	
	# Select one register from the bank as output, based on address pin
	add_part("mux_output", Mux4_8Way.new())
	connect_output("mux_output", "out", "out")
	connect_input("mux_output", "selector", "address")
	for i in range(size):
		connect_part("mux_output", "in%d" % i, "register%d" % i, "out")
	
	# Send load signal to correct register, based on address pin
	add_part("dmux_load", Dmux4_8Way.new())
	connect_input("dmux_load", "in", "load")
	connect_input("dmux_load", "selector", "address")
	for i in range(size):
		connect_part("register%d" % i, "load", "dmux_load", "out%d" % i)
	
	# Send input value to all registers
	for i in range(size):
		connect_input("register%d" % i, "in", "in")	
