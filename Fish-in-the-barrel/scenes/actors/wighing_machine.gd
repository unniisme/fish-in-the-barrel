extends Sprite2D

@onready var label = $Label

@export var poll = true # control whether to update constantly
@export var barrel : Barrel = null 

func _process(delta):
	if poll:
		update_count(barrel.get_count())

# For event based update
func update_count(count : int):
	label.text = str(count)
