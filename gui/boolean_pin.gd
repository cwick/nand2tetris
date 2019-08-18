extends CheckBox
signal pin_changed

var is_output setget _set_is_output, _get_is_output
var _is_output = false
var _pin : Dictionary

func _init(pin):
	_pin = pin
	self.text = pin["name"]

func get_value() -> int:
    return self.pressed as int

func set_value(value: int):
	self.pressed = value as bool

func _set_is_output(value):
    _is_output = value
    if _is_output:
        self.disabled = true
        self.focus_mode = Control.FOCUS_NONE

func _get_is_output():
    return _is_output
	
func _toggled(button_pressed):
	emit_signal("pin_changed")