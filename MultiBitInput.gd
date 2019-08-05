extends LineEdit

signal input_changed

func _ready():
	connect("text_changed", self, "_on_text_changed")
	
#warning-ignore: unused_argument
func _on_text_changed(new_text):
	emit_signal("input_changed")
	
func get_input() -> int:
	var arg := 0
	for c in text:
		if c == "0" or c == "1":
			arg <<= 1
			arg |= 1 if c == "1" else 0
	return arg