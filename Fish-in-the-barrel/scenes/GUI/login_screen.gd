extends Control

var username : TextEdit
var ip : TextEdit


func _ready():
	username = find_child("Username") as TextEdit
	ip = find_child("IP") as TextEdit
	
	if FileAccess.file_exists("user://fishbarrel.save"):
		var cookie = FileAccess.open("user://fishbarrel.save", FileAccess.READ)
		var data = cookie.get_line()
		username.text = data
	
	username.text_changed.connect(_handle_username_changed)
	ip.text_changed.connect(_handle_ip_changed)
	
	find_child("Startbutton").button_up.connect(_start)
	
func _handle_username_changed():
	GlobalManager.username = username.text
	
func _handle_ip_changed():
	GlobalManager.server_ip = ip.text

func _start():
	get_tree().change_scene_to_file("res://scenes/GUI/MainMenu.tscn")
	
	var cookie = FileAccess.open("user://fishbarrel.save", FileAccess.WRITE)
	var data = username.text
	cookie.store_line(data)
