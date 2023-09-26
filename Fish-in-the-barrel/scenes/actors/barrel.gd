extends Area2D

const PI = 3.14159265

var id : int;
@onready var lid = $Lid
var is_open = false

signal marked(id: int)
signal fish_landed(id : int)


func _open():
	lid.rotation_degrees = 90
	self.monitoring = true
	is_open = true

func _close():
	lid.rotation_degrees = 0
	self.monitoring = false	
	is_open = false
	
func _toggle_lid():
	if is_open: _close()
	else: 		_open()
	
func _mark():
	emit_signal("marked", id)


func _on_fish_entered(body):
	if body.is_in_group("fish"):
		emit_signal("fish_landed", id)


func _on_input_event(viewport, event : InputEvent, shape_idx):
	if event.is_pressed():
		_mark()
