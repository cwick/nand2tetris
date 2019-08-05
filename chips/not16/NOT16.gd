extends Object

const NOT = preload("res://chips/not/NOT.gd")
var _not := NOT.new()

func apply(input: int) -> int:
	var result := 0
	for i in range(16):
		var current_bit := input & (1 << i)
		result <<= 1
		result |= 1 if _not.apply(current_bit) else 0
		
	return result
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_not.free()