extends CheckBox

signal input_changed

func _ready():
	connect("pressed", self, "_on_pressed")
	
#warning-ignore: unused_argument
func _on_pressed():
	emit_signal("input_changed")
	
func get_input() -> bool:
	return pressed