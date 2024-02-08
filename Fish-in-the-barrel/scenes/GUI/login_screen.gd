extends Control

var username : TextEdit

func _ready():
	username = find_child("Username") as TextEdit
	
	if FileAccess.file_exists("user://fishbarrel.save"):
		var cookie = FileAccess.open("user://fishbarrel.save", FileAccess.READ)
		var data = JSON.parse_string(cookie.get_line()) as Dictionary
		if data.has("username"):
			GlobalManager.username = data["username"] 
			if data.has("difficulty"):
				GlobalManager.difficulty = float(data["difficulty"])
			else:
				_set_difficulty()
			_start()
	
	username.text_changed.connect(_handle_username_changed)
	
	find_child("Startbutton").button_up.connect(_start)
	
func _handle_username_changed():
	GlobalManager.username = username.text
	
func _start():
	_set_difficulty()
	get_tree().change_scene_to_file("res://scenes/ai_level_easy.tscn")
	
	var cookie = FileAccess.open("user://fishbarrel.save", FileAccess.WRITE)
	var data = JSON.stringify({
		"username" : username.text,
		"difficulty" : GlobalManager.difficulty
		})
	cookie.store_line(data)
	
	
func _set_difficulty():
	GlobalManager.difficulty = {
		0 : 0.25,
		1 : 0.75,
		2 : 1
	}[_random_sample([0.33, 0.33, 0.34])]


func _random_sample(probabilities: Array[float]) -> int:
	assert(probabilities.reduce(func(a,b): return a+b, 0) <= 1, "Distribution not valid")
	
	var random_value = randf()
	var cumulative_prob = 0.0
	
	for i in range(probabilities.size()):
		cumulative_prob += probabilities[i]
		if random_value < cumulative_prob:
			return i

	# If the loop completes without selecting, return -1
	return -1
