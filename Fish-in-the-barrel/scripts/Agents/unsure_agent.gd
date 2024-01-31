class_name ChanceAgent extends Agent
# Agent that has uncertainity in choosing barrel and deciding the number of fishes

var alpha : float

func _init(problem : FishProblem, alpha : float):
	self.problem = problem
	
	# Probability of choosing the correct barrel
	self.alpha = alpha

# Function that returns the best move predicted by the agent
## returns a list with one entry for each barrel. The barrel chosen to take
## from will have entry -1. Every barrel less than it entry 0. Barrels after it
## may have having a 0 or 1
func get_move() -> Array[int]:
	var outlist : Array[int] = []
	var found_first = false
	
	var max_barrel = -1
	
	var barrel_choose_distribution : Array[float] = []
	for barrel in problem.barrels:
		outlist.append(0)
		
		var count = barrel.get_count()
		if count == 0:
			barrel_choose_distribution.append(0)
		elif count%2 and not found_first:
			found_first = true
			barrel_choose_distribution.append(0)
			max_barrel = barrel.id
		else:
			barrel_choose_distribution.append(1)
	
	if max_barrel == -1:
		var barrel_choose_probability = 1/(
			barrel_choose_distribution.reduce(func (a,b) : return a+b, 0)
			)
		for i in range(problem.n):
			if barrel_choose_distribution[i] == 1:
				barrel_choose_distribution[i] = barrel_choose_probability
	else:
		var max_probability = pow(self.alpha, max_barrel+1)
		var barrel_choose_probability = (1 - max_probability)/(
			barrel_choose_distribution.reduce(func (a,b) : return a+b, 0)
			)
		for i in range(problem.n):
			if barrel_choose_distribution[i] == 1:
				barrel_choose_distribution[i] = barrel_choose_probability
		barrel_choose_distribution[max_barrel] = max_probability
		
	print("[unsure] choose dist = " + str(barrel_choose_distribution))
	var max_barrel_chosen = _random_sample(barrel_choose_distribution)
	if max_barrel_chosen == -1: #Only occurs if max barrel is the only choice
		max_barrel_chosen = max_barrel
	
		
	print("[unsure] choosing " + str(max_barrel_chosen))
	
	outlist[max_barrel_chosen] = -1
	
	for i in range(max_barrel_chosen+1, problem.n):
		var correct_choice = _toss(self.alpha)
		var is_even = problem.barrels[i].get_count()%2 == 0
		
		print("[unsure] barrel = " + str(i) + " correct_choice = " + str(correct_choice))
		
		if (correct_choice == is_even):
			outlist[i] = 0
		else:
			outlist[i] = 1
		
	
	_assert_answer_consistency(outlist)
	return outlist
	
func _toss(probability : float) ->  bool:
	assert(probability <= 1)
	
	return randf() < probability
	
func _random_sample(probabilities: Array[float]) -> int:
	assert(probabilities.reduce(func(a,b): return a+b, 0) <= 1, "Distribution not valid")
	
	var random_value = randf()
	var cumulative_prob = 0.0
	
	for i in range(probabilities.size()):
		cumulative_prob += probabilities[i]
		if random_value < cumulative_prob:
			return i

	# If the loop completes without selecting, return -1
	return -1
	
func _set_correct_probabilities(p : float):
	print("[unsure_agent][_set_correct_p] p = " + str(p))
	self.alpha = pow(p, 1.0/self.problem.n)
	print("[unsure_agent][_set_correct_p] alpha = " + str(self.alpha))
	
	
