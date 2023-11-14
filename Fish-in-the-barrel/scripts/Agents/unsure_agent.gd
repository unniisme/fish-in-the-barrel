class_name ChanceAgent extends Agent
# Agent that has uncertainity in choosing barrel and deciding the number of fishes

var p_choose : float
var p_add : float

func _init(problem : FishProblem, p_choose : float, p_add : float ):
	self.problem = problem
	
	# probability that a barrel might be chosen regardless of if it's the best move
	self.p_choose = p_choose
	
	# Probability that the number of fishes added is +1 or -1 from the best choice
	# p_add/2 is probability that a fish is added, 
	# p_add/2 is the probability that a fish is subtracted
	self.p_add = p_add

# Function that returns the best move predicted by the agent
## returns a list with one entry for each barrel. The barrel chosen to take
## from will have entry -1. Every barrel less than it entry 0. Barrels after it
## may have having a 0 or 1
func get_move() -> Array[int]:
	var outlist : Array[int] = []
	var found_first = false
	for barrel in problem.barrels:
		var count = barrel.get_count()
		
		var choose_override = _toss(self.p_choose)
		var add_override = _toss(self.p_add)
		
		# Add to barrel if it is odd
		if found_first:
			var add_value = 0
			if count%2:
				add_value += 1
				if add_override:
					if _toss(0.5):
						add_value += 1
					else:
						add_value -= 1
					
			else:
				if add_override:
					add_value += 1
					
			outlist.append(add_value)
		
		# barrel to deduct from
		elif count%2 or (choose_override and count != 0):
			outlist.append(-1)
			found_first = true
		
		# all barrels before max barrel
		else:
			outlist.append(0)
	
	# If no candidate found, simply deduct from the furthest barrel
	if not found_first:
		var last_index = problem.n - 1
		while last_index > 0:
			if problem.barrels[last_index].get_count() > 0:
				outlist[last_index] = -1
				break
			last_index -= 1
	
	_asser_answer_consistency(outlist)
	return outlist
	
#Toss a coin with the given probability of true
func _toss(p : float):
	
	return randf() < p
	
