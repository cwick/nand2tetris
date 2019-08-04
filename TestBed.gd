extends Node2D

func _ready():
	run()
	
func run():
	$Output.text = String($NAND.apply($InputA.pressed, $InputB.pressed))
	
func _on_input_pressed():
	run()
