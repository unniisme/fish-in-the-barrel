class_name FishProblem extends Node2D

const RAND_MIN : int = 1
const RAND_MAX : int = 7
const ADD_MAX : int = 5
const ADD_MIN : int = 0


var n : int
var barrels : Array[Barrel]
var _barrel_count_cache : Array[int]

		
func _update_barrel_cache():
	self._barrel_count_cache = []
	for barrel in barrels:
		self._barrel_count_cache.append(barrel.get_count()) 
		
func _get_count(barrel_id : int) -> int:
	# Returns the number of fishes in the given barrel, at the current state of the problem
	return _barrel_count_cache[barrel_id]

func is_over() -> bool:
#	return self.barrels.reduce(func(a,b): return a.get_count()+b.get_count(), 0) == 0

	# always calculate from cache
	return self._barrel_count_cache.reduce(func(a,b): return a+b, 0) == 0

func assert_move():
	var max_i = -1
	for i in range(n):
		var count = self.barrels[i].get_count()
		assert(count >= 0, 
			"Negative number of fishes in barrel %d" % i)
		if max_i < 0:
			if count == self._barrel_count_cache[i]:
				continue
			
			assert(count == self._barrel_count_cache[i] - 1,
					"Illegal change in max barrel %d, 
					expected: %d\t obtained: %d" % [i, 
									self._barrel_count_cache[i] - 1,  
									count]
					)
			max_i = i
		
		else:
			assert(count >= self._barrel_count_cache[i],
					"Illegal change in barrel %d" % i )
				
	_update_barrel_cache()

func _to_string():
	return str(self.n) + " " + str(self._barrel_count_cache)
