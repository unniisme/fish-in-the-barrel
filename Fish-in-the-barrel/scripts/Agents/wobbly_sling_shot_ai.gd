class_name ChanceSlingShotAgent extends SlingShotAgent

## Shoots slingshot into required barrel

var gamma : float
var wobble_modifier = 0.05

func _init(slingShot : Slingshot, barrelManager : BarrelManager, 
			gamma : float):
	
	# Uncertainity in slingshot target position
	# Equal to area of barrel opening / area where fish could land
	self.gamma = gamma
	
	super._init(slingShot, barrelManager)
	

func _do_slingshot(barrel : Barrel):
	var uy = -sqrt(2*g*max_height)
	
	var x = barrel.position.x
	
	print("[wobbly] x = " + str(x))
	# Probability calculations
	x += wobble_modifier * (randf()-0.5)*barrel.diameter/self.gamma
	
	print("[wobbly] x = " + str(x))	
	
	var ux = (x - slingShot.position.x) * g / (2 * uy)
	
	var vel = Vector2(-ux * modifier, uy)
	var pos = -vel/slingShot.force  # Mouse position calculation. Assume no cutoff for now
	
	
	slingShot._update_mouse_pos(pos)
	slingShot.shoot()

func _set_correct_probability(p : float):
	# Given the output probability of the model, calculate gamma value
	# Not correct but will have to work with for now
	self.gamma = pow(p, self.barrelManager.N/2)
