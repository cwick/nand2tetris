extends VBoxContainer
signal pin_changed

var is_output setget _set_is_output, _get_is_output
var _is_output = false
var _pin : Dictionary

func _init(pin):
	_pin = pin
	var container := GridContainer.new()
	var pin_label := Label.new()
	pin_label.text = pin["name"]
	pin_label.align = HALIGN_CENTER
	
	self.add_child(pin_label)
	self.add_child(container)
	container.columns = pin["bits"]
	container.name = "PinContainer"
	container.add_constant_override("vseparation", 0)
	container.add_constant_override("hseparation", 0)
	
	for i in range(container.columns):
		var bit_label := Label.new()
		bit_label.text = String(container.columns - i - 1)
		bit_label.align = HALIGN_CENTER
		container.add_child(bit_label)
		
	for i in range(container.columns):
		var checkbox := CheckBox.new()
		checkbox.name = "Pin%d" % (container.columns - i - 1)
		checkbox.connect("toggled", self, "_on_checkbox_toggled")
		container.add_child(checkbox)
		
func get_value() -> int:
	var value := 0
	for i in range(_pin["bits"]):
		var checkbox = $PinContainer.get_node("Pin%d" % i) as CheckBox
		value |= (checkbox.pressed as int) << i
	return value

func set_value(value: int):
	for i in range(_pin["bits"]):
		var checkbox = $PinContainer.get_node("Pin%d" % i) as CheckBox
		checkbox.pressed = (value & (1 << i)) as bool

func _set_is_output(value):
	_is_output = value
	if _is_output:
		for child in $PinContainer.get_children():
			if child is CheckBox:
				child.disabled = true
				child.focus_mode = Control.FOCUS_NONE

func _get_is_output():
	return _is_output

func _on_checkbox_toggled(unused):
	emit_signal("pin_changed")