extends Label

func set_text(text):
	.set_text(_convert_to_binary(int(text)))
	
func _convert_to_binary(value):
	var string_value = ""
	for i in range(16):
		string_value += "1" if (value & (1 << i)) > 0 else "0"
	return string_value