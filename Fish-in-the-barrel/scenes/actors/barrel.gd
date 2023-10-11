class_name Barrel extends Area2D

const PI = 3.14159265

var id : int;
@onready var lid = $Lid
var is_open = false
var count = 0
var fishes : Array[Node2D]

@export var lid_hinge_k = 20

signal touched(id : int)

func _physics_process(delta):
	if is_open:
		lid.rotate((0.5*PI - lid.rotation)*lid_hinge_k*delta)
	else:
		lid.rotate((0 - lid.rotation)*lid_hinge_k*delta)
		

func _open():
#	self.monitoring = true
	is_open = true

func _close():
#	self.monitoring = false	
	is_open = false
	
func _toggle_lid():
	if is_open: _close()
	else: 		_open()
	
#func _add_fish(fish):
#	count += 1
#	fishes.append(fish)
#	print(id, " ", count)
	
func _pop_fish():
	get_overlapping_bodies()[0].queue_free()
	
#func _remove_fish(fish):
#	count -= 1
#	fishes.erase(fish)
#	print(id, " ", count)	

#func _on_fish_entered(body):
#	if body.is_in_group("fish"):
#		_add_fish(body)
#
#func _on_fish_exited(body):
#	if body.is_in_group("fish"):
#		_remove_fish(body)

func get_count():
	return len(get_overlapping_bodies())
	
func _on_input_event(viewport, event : InputEvent, shape_idx):
	if event.is_pressed():
		emit_signal("touched", self.id)


