extends Object

const NAND = preload("res://chips/nand/NAND.gd")
var _nand = NAND.new()

func apply(a: bool) -> bool:
	return _nand.apply(a, a)