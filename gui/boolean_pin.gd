extends CheckBox

func get_value() -> int:
    return self.pressed as int

func set_value(value: int):
	self.pressed = value as bool

