extends RigidBody2D

var pop_force = 200

func kill():
	$CollisionShape2D.disabled = true
	var pop_dir = Vector2((randf()*2)-1, -1)
	apply_impulse(pop_dir * pop_force)
	
	await get_tree().create_timer(2).timeout
	
	queue_free()
