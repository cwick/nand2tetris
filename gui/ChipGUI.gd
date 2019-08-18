extends Node

export(String, FILE, "*.gd") var chip
const Chip = preload("res://chips/chip.gd")

var _chip: Chip

func _ready():
	if chip == "" or chip == null:
		return

	var ChipClass = load(chip)
	var input_container = find_node("InputContainer")
	var output_container = find_node("OutputContainer")
	_clear_container(input_container)
	_clear_container(output_container)

	_chip = ChipClass.new()

	find_node("ChipName").text = _chip.name
	
	for pin in _chip.get_input_pins():
		var checkbox = _create_pin_gui(pin)
		checkbox.connect("toggled", self, "_on_input_changed")
		input_container.add_child(checkbox)

	for pin in _chip.get_output_pins():
		var checkbox = _create_pin_gui(pin)
		checkbox.disabled = true
		checkbox.focus_mode = Control.FOCUS_NONE
		output_container.add_child(checkbox)

	_evaluate_chips()

func _clear_container(container: Container):
	for child in container.get_children():
		child.free()
	
func _on_input_changed(pressed):
	_evaluate_chips()
	
func _evaluate_chips():
	var input = []
	for pin in find_node("InputContainer").get_children():
		input.append(pin.get_value())

	var result := _chip.evaluate(input)
	for output_pin in find_node("OutputContainer").get_children():
		output_pin.set_value(result[output_pin.get_index()])

func _create_pin_gui(pin):
	var control := CheckBox.new()
	control.text = pin["name"]
	control.set_script(load("res://gui/boolean_pin.gd"))
	return control