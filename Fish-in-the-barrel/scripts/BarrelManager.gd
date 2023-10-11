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
		var barrel := child as Barrel # Typecast nonsense
		barrels.append(barrel)
	N = barrels.size() 
		
	for i in range(N):
		barrels[i].id = i
	
	_connect_barrels()
	
func _process(delta):
	if Input.is_action_just_pressed("Action1"):
		handle_action()
	
func _connect_barrels():
	# Connect the "touched" signal of each barrel to handler in barrel manager
	for barrel in barrels:
		barrel.touched.connect(barrel_touched)

func barrel_touched(id : int):
	# Handle the input from the barrel depending on the state of the game
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

func handle_action():
	if state == STATE.INIT:
		problem = FishProblem.new(N, barrels)
		print(problem)
		state = STATE.CHOOSING
	
	elif state == STATE.ADDING:
		for barrel in problem.barrels:
			barrel._close()
		problem.assert_move()
		
		if problem.is_over():
			print("Game completed")
			get_tree().quit()
			
		max_barrel = -1
		state = STATE.CHOOSING
		
	print("Choose a barrel")
		
		
