extends Control

@onready var slider : HSlider = find_child("HSlider")
@onready var label : Label = find_child("SliderVal")
@onready var button : Button = find_child("Button")

func _ready():
	slider.value_changed.connect(_on_slider_value_changed)
	button.button_up.connect(func (): 
		get_tree().change_scene_to_file("res://scenes/ai_level_easy.tscn"))
	
func _on_slider_value_changed(val : float):
	if val < 25:
		label.text = "Very Easy"
	elif val < 50:
		label.text = "Easy"
	elif val < 75:
		label.text = "Moderate"
	elif val < 100:
		label.text = "Challenging"
	elif val == 100:
		label.text = "Perfectly logical opponent"
	GlobalManager.difficulty = (val/200) + 0.5
	
