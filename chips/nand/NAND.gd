extends Object

func apply(a, b) -> bool:
	return !(a && b)
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		print('NAND deleted')