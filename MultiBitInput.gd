extends LineEdit

signal input_changed

func _ready():
	connect("text_changed", self, "_on_text_changed")
	
#warning-ignore: unused_argument
func _on_text_changed(new_text):
	emit_signal("input_changed")
	