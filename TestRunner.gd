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
	
	var input = $Input0
	var i = 0
	while input != null:
		input.connect("pressed", self, "_on_input_pressed")
		i += 1
		input = get_node_or_null("Input" + String(i))
	
	run()
	
func run():
	var _chip = get_node(chip)
	var input: Button = $Input0
	var i = 0
	var args = []
	while input != null:
		args.append(input.pressed)
		i += 1
		input = get_node_or_null("Input" + String(i))
		
	$Output.text = String(_chip.callv("apply", args))
	
func _on_input_pressed():
	run()
