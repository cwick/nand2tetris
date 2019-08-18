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
	var interface = _chip.public_interface

	$ChipName.text = _chip.name
	
	for pin in interface["input_pins"]:
		var checkbox = CheckBox.new()
		checkbox.text = pin["name"]
		checkbox.connect("toggled", self, "_on_input_changed")
		input_container.add_child(checkbox)

	for pin in interface["output_pins"]:
		var checkbox = CheckBox.new()
		checkbox.text = pin["name"]
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
	for node in find_node("InputContainer").get_children():
		input.append(node.pressed)

	var result := _chip.evaluate(input)
	for child in find_node("OutputContainer").get_children():
		child.pressed = result[child.get_index()]
