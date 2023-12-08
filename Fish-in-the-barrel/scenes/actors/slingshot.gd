class_name Slingshot extends Area2D

# To be necessarily attached game manager

var fishScene = load("res://scenes/actors/fish.tscn")

var focusing = false
var take_input = true
var mouse_pos = Vector2(0,0)
var shoot_velocity = Vector2(0,0)

@export_category("Slingshot properties")
@export var cutoff = 60
@export var force = 15

@export_category("Draw properties")
@export var num_points = 10
@export var time_gap = 100
@export var fade = 0.85	
@export var draw_mod = 0.97 

@onready var g_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
@onready var g = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if focusing and take_input:
		_update_mouse_pos(get_local_mouse_position())
		
		if Input.is_action_just_released("Sling"):
			
			shoot()
			
			focusing = false

func shoot():
	var fish_instance : RigidBody2D = fishScene.instantiate()
	add_child(fish_instance)
	fish_instance.linear_velocity = shoot_velocity
	
func _recalculate_velocity():
	shoot_velocity = -mouse_pos.normalized() \
					* min(cutoff, mouse_pos.length()) \
					* force
	
	# Draw arc
	queue_redraw()
	
func _update_mouse_pos(pos):
	mouse_pos = pos
	_recalculate_velocity()

func _on_input_event(viewport, event : InputEvent, shape_idx):
	if event.is_action_pressed("Sling"):
		focusing = true


func _draw():
	
	var alpha = 1
	for i in range(num_points):
		var t = i * time_gap
		var pos = (0.5 * g_vector * t * t + draw_mod * shoot_velocity * t)/g
	
		var col = Color(0,0,0,alpha)
		draw_circle(pos, 2, col)
		alpha *= fade
	
	
	
