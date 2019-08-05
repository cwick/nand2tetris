tool
extends Node

export(NodePath) var chip = null

func _get_configuration_warning():
	if chip == null or chip.is_empty():
		return "chip is required"
	elif $Input0 == null:
		return "missing inputs"
	else:
		return ""
	
func _ready():
	if Engine.is_editor_hint():
		return
	
	for input in get_inputs():
		input.connect("pressed", self, "_on_input_pressed")
	
	run()
	
func run():
	var _chip = get_node(chip)
	var args = []
	for input in get_inputs():
		args.append(input.pressed)
			
	var result = _chip.callv("apply", args)
	if result is Array:
		for i in range(result.size()):
			get_node("Output" + String(i)).text = String(result[i])
	else:
		$Output.text = String(result)
			
	
func get_inputs():
	var input = $Input0
	var i = 0
	var input_list = []
	while input != null:
		input_list.append(input)
		i += 1
		input = get_node_or_null("Input" + String(i))
	
	return input_list
	
	
func _on_input_pressed():
	run()
