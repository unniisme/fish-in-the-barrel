class_name ChanceSlingShotAgent extends SlingShotAgent

## Shoots slingshot into required barrel

var t_x : float
var t_y : float

func _init(slingShot : Slingshot, barrelManager : BarrelManager, 
			temparature_x : float, temparature_y : float):
	
	# Uncertainity in x direction of slinshot pos
	# 0 -> no uncertainity
	# 1 -> x could vary be as much as half of itself
	self.t_x = temparature_x
	self.t_y = temparature_y
	
	super._init(slingShot, barrelManager)
	

func _do_slingshot(barrel : Barrel):
	var uy = -sqrt(2*g*max_height)
	
	var x = barrel.position.x
	
	var ux = (x - slingShot.position.x) * g / (2 * uy)
	
	var vel = Vector2(-ux * modifier, uy)
	var pos = -vel/slingShot.force  # Mouse position calculation. Assume no cutoff for now
	
	# Probability calculations
	pos.x += (pos.x) * (randf() - 0.5) * self.t_x
	pos.y += (pos.y) * (randf() - 0.5) * self.t_y
	
	slingShot._update_mouse_pos(pos)
	slingShot.shoot()
