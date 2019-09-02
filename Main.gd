extends Container

func _ready():
    for child in get_children():
        child.queue_free()

    _add_chips_from_directory("res://chips/native", ["dmux4_8way", "mux4_8way"])
    _add_chips_from_directory("res://chips", ["chip", "simulated_chip"])

func _add_chips_from_directory(dir_name: String, exclude = []):
    var dir := Directory.new()
    dir.open(dir_name)
    dir.list_dir_begin(true, true)
    var file := dir.get_next()
    var gui_resource = load("res://gui/ChipGUI.tscn")

    while file != '':
        if !dir.current_is_dir() and not file.get_basename() in exclude:
            var gui = gui_resource.instance()
            gui.chip = dir.get_current_dir().plus_file(file)
            
            add_child(gui, true)
        file = dir.get_next()

func _on_Tick_pressed():
	get_tree().call_group("chips", "tick")
