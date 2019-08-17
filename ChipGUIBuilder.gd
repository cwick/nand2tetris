extends Container

func _ready():
    for child in get_children():
        child.queue_free()

    _add_chips_from_directory("res://chips/native")
    _add_chips_from_directory("res://chips")
    

func _add_chips_from_directory(dir_name: String):
    var dir := Directory.new()
    dir.open(dir_name)
    dir.list_dir_begin(true, true)
    var file := dir.get_next()
    var gui_resource = load("res://ChipGUI.tscn")

    while file != '':
        if file != "chip.gd" and file != "simulated_chip.gd" and !dir.current_is_dir():
            var gui = gui_resource.instance()
            gui.chip = dir.get_current_dir().plus_file(file)
            
            add_child(gui, true)
        file = dir.get_next()
