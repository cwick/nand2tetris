extends Object

const NAND = preload("res://chips/nand/NAND.gd")
const NOT = preload("res://chips/not/NOT.gd")
var _nand = NAND.new()
var _not = NOT.new()

func apply(a: bool, b: bool) -> bool:
	return _not.apply(_nand.apply(a, b))