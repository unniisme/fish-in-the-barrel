class_name BarrelManager extends Node2D

# To be necessarily attached game manager

enum STATE {INIT, CHOOSING, ADDING}

var N = 4
var max_barrel = -1
var problem : FishProblem
var state = STATE.INIT
var barrels : Array[Barrel] = []

func _ready():
	for child in get_children():
		if child is Barrel:
			barrels.append(child)
	N = barrels.size() 
		
	for i in range(N):
		barrels[i].id = i
		
	var initial_barrel_counts : Array[int] = []
	for i in range(N):
		# 1-8 fishes in each barrel
		initial_barrel_counts.append(GlobalManager.random_sample_normalised(
			[1,4,5,5,5,4,2,1]
		))
		barrels[i].spawn_fishes(initial_barrel_counts[-1])
		
	# Initialize problem
	problem = $FishProblem
	problem.n = N
	problem.barrels = barrels
	
	problem._barrel_count_cache = initial_barrel_counts # Override
	print(problem)
	
	_connect_barrels()
	
func _process(delta):
	# hack to intitialize everything properly
	if state == STATE.INIT:
		handle_action()
	
func _connect_barrels():
	# Connect the "touched" signal of each barrel to handler in barrel manager
	# Figured if I am doing this, I don't readlly need signals at all but whatever
	for barrel in barrels:
		barrel.touched.connect(barrel_touched)

# Handle the input from the barrel depending on the state of the game
func barrel_touched(id : int):
	if state == STATE.INIT:
		barrels[id]._toggle_lid()
	
	elif state == STATE.CHOOSING:
		if problem.barrels[id].get_count() == 0:
			return
		
		for i in range(id+1):
			problem.barrels[i]._close()
		for i in range(id+1, N):
			problem.barrels[i]._open()
		max_barrel = id
		problem.barrels[id]._pop_fish()
		
		print("Choosing barrel %d, add fishes" % id)
		state = STATE.ADDING

func handle_action() -> bool:
	if state == STATE.INIT:
#		problem._update_barrel_cache()
		
		state = STATE.CHOOSING
		get_parent().update_problem(problem) # update in problem manager
		
		print("Initialized. Choose a barrel")
		return true
		
	elif state == STATE.ADDING:
		for barrel in problem.barrels:
			barrel._close()
		problem.assert_move()
			
		max_barrel = -1
		state = STATE.CHOOSING
		
		print("Move completed. Choose a barrel")
		return true
		
	print("No move. Choose a barrel")
	return false
		
		
