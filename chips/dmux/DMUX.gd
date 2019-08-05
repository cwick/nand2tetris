extends Object

const AND = preload("res://chips/and/AND.gd")
const NOT = preload("res://chips/not/NOT.gd")
var _and := AND.new()
var _not := NOT.new()

func apply(input: bool, selector: bool) -> Array:
	return [_and.apply(
				_not.apply(selector),
				input),
			_and.apply(
				input,
				selector)]
	
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_and.free()
		_not.free()