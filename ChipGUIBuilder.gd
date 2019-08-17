extends Container

func _ready():
    var dir := Directory.new()
    dir.open("res://chips")
    dir.list_dir_begin(true, true)
    var file := dir.get_next()
    var gui_resource = load("res://ChipGUI.tscn")

    while file != '':
        if file != "chip.gd" and file != "simulated_chip.gd" and !dir.current_is_dir():
            var gui = gui_resource.instance()
            gui.chip = "res://chips/" + file
            
            add_child(gui, true)
        file = dir.get_next()
