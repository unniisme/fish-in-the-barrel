extends Control


func _ready():
	find_child("Label").text = GlobalManager.current_winner
	find_child("Button").button_up.connect(func (): 
		get_tree().change_scene_to_file("res://scenes/GUI/login_screen.tscn"))
		
