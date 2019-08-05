extends Object

const AND = preload("res://chips/and/AND.gd")
const OR = preload("res://chips/or/OR.gd")
const NOT = preload("res://chips/not/NOT.gd")
var _and := AND.new()
var _or := OR.new()
var _not := NOT.new()

func apply(a: bool, b: bool) -> bool:
	return _and.apply(
		_or.apply(a, b),
		_or.apply(_not.apply(a), _not.apply(b)))
	
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_and.free()
		_not.free()
		_or.free()