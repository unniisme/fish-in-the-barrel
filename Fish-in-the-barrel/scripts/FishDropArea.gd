extends Area2D

var fishScene = load("res://scenes/actors/fish.tscn")

func _drop_fish_on_mouse():
	var fish_instance : RigidBody2D = fishScene.instantiate()
	add_child(fish_instance)
	var mouse_pos = get_global_mouse_position()
	fish_instance.position = mouse_pos
	
	


func _on_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		_drop_fish_on_mouse()
