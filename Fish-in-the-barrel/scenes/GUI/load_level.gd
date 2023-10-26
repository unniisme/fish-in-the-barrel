extends Button

@export_file("*.tscn") var scene

func _ready():
	connect("button_up", switch_level)
	
func switch_level():
	get_tree().change_scene_to_file(scene)
