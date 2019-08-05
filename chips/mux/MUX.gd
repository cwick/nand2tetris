extends Object

const AND = preload("res://chips/and/AND.gd")
const OR = preload("res://chips/or/OR.gd")
const NOT = preload("res://chips/not/NOT.gd")
var _and := AND.new()
var _or := OR.new()
var _not := NOT.new()

func apply(a: bool, b: bool, selector: bool) -> bool:
	return _or.apply(
		_and.apply(_not.apply(selector), a),
		_and.apply(selector, b))
	
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_and.free()
		_not.free()
		_or.free()