extends Reference

var implementation = null

func evaluate(input=null):
	if implementation:
		return implementation.evaluate(input)

	return false