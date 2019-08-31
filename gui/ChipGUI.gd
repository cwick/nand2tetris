extends Node

export(String, FILE, "*.gd") var chip
const Chip = preload("res://chips/chip.gd")
const MultiBitPinGui = preload("res://gui/multibit_pin.gd")
const BooleanPinGui = preload("res://gui/boolean_pin.gd")
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
		var gui = _create_pin_gui(pin)
		gui.connect("pin_changed", self, "_evaluate_chips")
		input_container.add_child(gui)

	for pin in _chip.get_output_pins():
		var gui = _create_pin_gui(pin)
		gui.is_output = true
		output_container.add_child(gui)

	_evaluate_chips()

func _clear_container(container: Container):
	for child in container.get_children():
		child.free()

func _evaluate_chips():
	var input = []
	for pin in find_node("InputContainer").get_children():
		input.append(pin.get_value())

	_chip.invalidate()
	var result := _chip.evaluate(input)
	for output_pin in find_node("OutputContainer").get_children():
		output_pin.set_value(result[output_pin.get_index()])

func _create_pin_gui(pin):
	if pin["bits"] == 1:
		return BooleanPinGui.new(pin)
	return MultiBitPinGui.new(pin)