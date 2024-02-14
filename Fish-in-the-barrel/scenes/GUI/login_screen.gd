extends Control

var username : TextEdit
var difficulty_value = 1

func _ready():
	
	if FileAccess.file_exists("user://fishbarrel.save"):
		var cookie = FileAccess.open("user://fishbarrel.save", FileAccess.READ)
		var data = JSON.parse_string(cookie.get_line())
		
		if data is Dictionary:
			if data.has("username"):
				GlobalManager.username = data["username"] 
				if data.has("difficulty"):
					difficulty_value = float(data["difficulty"])
				else:
					difficulty_value = _roll_difficulty()
			_start()
	
	username = find_child("Username") as TextEdit
	username.text_changed.connect(_handle_username_changed)
	find_child("Startbutton").button_up.connect(_start_button_pressed)
	
func _handle_username_changed():
	GlobalManager.username = username.text

func _start_button_pressed():
	difficulty_value = _roll_difficulty()
	_start()

func _start():
	var cookie = FileAccess.open("user://fishbarrel.save", FileAccess.WRITE)
	var data = JSON.stringify({
		"username" : GlobalManager.username,
		"difficulty" : GlobalManager.difficulty
		})
	cookie.store_line(data)
	
	
	if difficulty_value > 0:
		GlobalManager.difficulty = difficulty_value
		get_tree().change_scene_to_file("res://scenes/ai_level_easy.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/GUI/difficulty_menu.tscn")
	
func _roll_difficulty():
	return {
		0 : -1,
		1 : 0.45,
		2 : 1
	}[GlobalManager.random_sample([0.33, 0.33, 0.34])]
