class_name GameStats extends Summariser

# To hold data about each run and store/send that data

## game_states = { move_number : { 
## 						"state" : state before this move (list)
##						"move"  : This move (list) 
##						"player": player of this move (str|int)
##					}
##				}
var game_states : Dictionary
var winner : String = ""
var num_moves : int = 0

func _ready():
	
	_log("Booting GameStats and Summariser", LOGLEVELS.INFO)
	
func _update_state(state : Array[int], player : String):
	
	game_states[num_moves] = {"state" : state}
	game_states[num_moves]["player"] = player
	_log("Updating game state", LOGLEVELS.INFO)
	
func _update_move(move : Array[int]):
	
	game_states[num_moves]["move"] = move
	num_moves += 1
	_log("Updating game moves", LOGLEVELS.INFO)
	
func _summarise():
	_log("Summarizing", LOGLEVELS.INFO)
#	_send_data("gamestat", game_states)
