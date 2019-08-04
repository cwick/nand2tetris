extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	run()
	
func run():
	$Output.text = String($NAND.apply($InputA.pressed, $InputB.pressed))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_input_pressed():
	run()
