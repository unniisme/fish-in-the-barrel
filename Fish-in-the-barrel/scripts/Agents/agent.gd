class_name Agent
# Base agent. Ideal

var problem : FishProblem

func _init(problem : FishProblem):
	self.problem = problem
	
func _asser_answer_consistency(answer : Array):
	print("Move: ", answer)
	var hit_max_barrel = false
	for entry in answer:
		if entry == -1:
			hit_max_barrel = true
		
		assert(hit_max_barrel or entry == 0, "Illegal entry %d"%entry)
	assert(hit_max_barrel, "No max barrel")

# Function that returns the best move predicted by the agent
## returns a list with one entry for each barrel. The barrel chosen to take
## from will have entry -1. Every barrel less than it entry 0. Barrels after it
## may have having a 0 or 1
func get_move() -> Array[int]:
	var outlist : Array[int] = []
	var found_first = false
	for barrel in problem.barrels:
		var count = barrel.get_count()
		# Add to barrel if it is odd
		if found_first:
			if count%2:
				outlist.append(1)
			else:
				outlist.append(0)
		
		# barrel to deduct from
		elif count%2:
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
	
