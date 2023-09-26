extends Node2D

var N = 4
var curr_player = 0

var problem = FishProblem.new(N, [])

# Signals
signal game_over(winning_player : int)
signal made_move(i : int, moveArray : Array)

# Reactor functions
func _perform_move(open_barrel : int, overhead_array : Array):
	if open_barrel == -1:
		return
	
	var move_array = overhead_array.slice(open_barrel)
		
	problem.move(open_barrel, move_array)
	
	emit_signal("made_move", open_barrel, move_array)
	
	if problem.is_over():
		emit_signal("game_over", curr_player)
		
	_switch_player()
	
func _perform_move_from_tree():
	var barrel_manager : BarrelManager = $BarrelManager
	_perform_move(barrel_manager.max_barrel, barrel_manager.overhead_array)
	
func _switch_player():
	curr_player = 1 - curr_player


