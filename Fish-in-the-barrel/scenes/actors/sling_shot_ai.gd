extends Node2D

# To be necessarily attached game manager

## Shoots slingshot into required barrel

var slingShot : Slingshot
var barrelManager : BarrelManager
var g

@export var max_height = 150
@export var modifier = 1.15

func _ready():
	slingShot = get_node("../Slingshot")
	assert(slingShot != null, "No Slingshot")
	
	g = slingShot.g
	
	barrelManager = get_node("../BarrelManager")
	assert(barrelManager != null, "No BarrelManager")
	

func _do_slingshot(barrel : Barrel):
	var uy = -sqrt(2*g*max_height)
	
	var x = barrel.position.x
	
	var ux = (x - slingShot.position.x) * g / (2 * uy)
	
	var vel = Vector2(-ux * modifier, uy)
	var pos = -vel/slingShot.force  # Mouse position calculation. Assume no cutoff for now
	
	slingShot._update_mouse_pos(pos)
	slingShot.shoot()
