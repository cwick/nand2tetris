extends Reference

var implementations = []

func evaluate(input):
	if implementations.size() > 0:
		if input.size() > 0:
			var a = implementations[0].evaluate([input[0], input[1]])
			if implementations.size() > 1:
				return implementations[1].evaluate([a, input[2]])
			return a

		return implementations[0].evaluate(input)
	return false