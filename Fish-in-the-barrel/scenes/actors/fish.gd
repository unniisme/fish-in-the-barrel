extends RigidBody2D

var pop_force = 200
var velocity_old = Vector2.ZERO

func _process(delta):
	if (linear_velocity - velocity_old).length() > 200:
		AudioManager.play("Splat")
	velocity_old = linear_velocity

func kill():
	$CollisionShape2D.disabled = true
	var pop_dir = Vector2((randf()*2)-1, -1)
	apply_impulse(pop_dir * pop_force)
	
	await get_tree().create_timer(2).timeout
	
	queue_free()
