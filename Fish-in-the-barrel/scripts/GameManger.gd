class_name GameManager extends Control

## Tree structure:
#	Manager
#		|- UI elements
#		|- BarrelManager
#			|- Barrels
#		|- SlingShot

enum GAMEMODE {PVP, PVE, ONEPLAYER}

@export var gameMode : GAMEMODE

## Only for AI gamemodes 
@export_category("AI properties")
@export_range(0,1) var chance_agent_p : float
@export_range(0,1) var slingshot_agent_p : float


@onready var barrelManager : BarrelManager = $BarrelManager
@onready var playerInfo : Label = $PlayerInfo
@onready var slingshot : Slingshot = $Slingshot
@onready var stats : GameStats = $GameStats
var agent : Agent
var slingShotAgent : SlingShotAgent

var playing = false # true - player 0 playing. false - player 1 playing.
var move_locked = false

# Statistics

func _ready():
	if gameMode == GAMEMODE.PVE:
		agent = ChanceAgent.new(barrelManager.problem, 1)
		agent._set_correct_probabilities(chance_agent_p)
		print("[chance agent] alpha = " + str(agent.alpha))
		
		slingShotAgent = ChanceSlingShotAgent.new(slingshot, barrelManager, 0)
		slingShotAgent._set_correct_probability(slingshot_agent_p)
		print("[slingshot agent] gamma = " + str(slingShotAgent.gamma))
	
	stats._log(get_tree().get_current_scene().get_name(), Summariser.LOGLEVELS.INFO)
	_handle_player_action()

func _process(delta):
	if Input.is_action_just_pressed("Action1"):
		_end_move()
		
# Handle action depending on who is playing
func _handle_player_action():
	playing = not playing
	playerInfo.text = _currently_playing()
	print("(", _currently_playing(), ")")
	
	if gameMode == GAMEMODE.PVE:
		if playing:
			slingshot.take_input = true # enable player controls
		else:
			slingshot.take_input = false # disable player controls
			move_locked = true
			_do_AI_move()
			
			
# Calculate AI move and perform it
func _do_AI_move():
	var move = agent.get_move()
	var max_barrel = move.find(-1)
	
	# Choose barrel
	barrelManager.barrel_touched(max_barrel)
	
	await get_tree().create_timer(1).timeout
	
	# Fire into each required barrel
	for i in range(max_barrel, move.size()):
		if move[i] > 0:
#			slingshot.shoot_to_barrel(i)
			slingShotAgent._do_slingshot(barrelManager.barrels[i])
			await get_tree().create_timer(1).timeout
			
	await get_tree().create_timer(1).timeout
	
	move_locked = false
	_end_move()
	
func _end_move():
	if move_locked:
		return
		
	if barrelManager.problem:
		print("Here")
		stats._log(
			"Updating stat with following :" + str(barrelManager.problem._barrel_count_cache),
			Summariser.LOGLEVELS.DEBUG)
		stats._update_state(barrelManager.problem._barrel_count_cache, _currently_playing())
	
	# Update problem
	var made_move = barrelManager.handle_action()
	
	# Summarise
	if barrelManager.problem:
		stats._update_move([])
	
	# end game
	if barrelManager.problem.is_over():
		print(_currently_playing(), " won")
		
		## Switch scene back to main menu
		_exit_to_menu()
		
	if made_move:
		_handle_player_action()
		
func _currently_playing():
	match gameMode:
		GAMEMODE.PVE:
			return "Human Player" if playing else "AI Player"
		GAMEMODE.ONEPLAYER:
			return "Singleplayer"
	return "Player 0" if playing else "Player 1"

# to be called by barrelmanager if it updates the problem
func update_problem(problem : FishProblem):
	if agent:
		agent.problem = problem
		
func _exit_to_menu():
	print("Quiting to main menu")
	
	## Send summary
	stats._summarise()
	
#	stats._wait_for_empty_queue()
	
	get_tree().change_scene_to_file("res://scenes/GUI/MainMenu.tscn")
