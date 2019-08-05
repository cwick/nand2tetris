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
		input.connect("input_changed", self, "_on_input")
	
	run()
	
func run():
	var _chip = get_node(chip)
	var args = []
	for input in get_inputs():
		if input is Button:
			args.append(input.pressed)
		elif input is LineEdit:
			var arg := 0
			for c in input.text:
				if c == "0" or c == "1":
					arg <<= 1
					arg |= 1 if c == "1" else 0
			args.append(arg)
			
	var result = _chip.callv("apply", args)
	if result is Array:
		for i in range(result.size()):
			get_node("Output" + String(i)).text = String(result[i])
	else:
		$Output.set_text(String(result))
			
	
func get_inputs():
	var input = $Input0
	var i = 0
	var input_list = []
	while input != null:
		input_list.append(input)
		i += 1
		input = get_node_or_null("Input" + String(i))
	
	return input_list
	
#warning-ignore:unused_argument
func _on_text_input(new_text):
	run()
		
func _on_input():
	run()
