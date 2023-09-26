class_name FishProblem

const RAND_MIN : int = 1
const RAND_MAX : int = 7
const ADD_MAX : int = 5
const ADD_MIN : int = 0


var n : int
var barrels : Array

func _init(n : int, args : Array):
	self.n = n
	self.barrels = []
	for i in range(n):
		if i < args.size():
			self.barrels.append(args[i])
		else:
			self.barrels.append(randi_range(RAND_MIN, RAND_MAX))

func copy() -> FishProblem:
	return FishProblem.new(self.n, self.barrels)

func _hash() -> int:
	return self.barrels.hash()

func is_over() -> bool:
	return self.barrels.reduce(func(a,b): return a+b, 0) == 0

func move(k : int, subs : Array) -> bool:
	print(k, subs)
	if self.barrels[k] == 0:
		return false

	self.barrels[k] -= 1
	var upper = min(self.n, k + 1 + subs.size())
	for i in range(k + 1, upper):
		self.barrels[i] += subs[i - (k + 1)]

	return true

func _to_string():
	return str(self.n) + " " + str(self.barrels)
