extends Node
const AndChip = preload("res://chips/and.gd")

func _ready():
	var input_container = find_node("InputContainer")
	var output_container = find_node("OutputContainer")
	_clear_container(input_container)
	_clear_container(output_container)

	var chip := AndChip.new()
	var interface = chip.public_interface

	$ChipName.text = chip.name
	
	for pin in interface["input_pins"]:
		var checkbox = CheckBox.new()
		checkbox.text = pin["name"]
		input_container.add_child(checkbox)

	for pin in interface["output_pins"]:
		var checkbox = CheckBox.new()
		checkbox.text = pin["name"]
		checkbox.disabled = true
		output_container.add_child(checkbox)

func _clear_container(container: Container):
	for child in container.get_children():
		child.queue_free()