class_name BarrelManager extends Node2D

@export var N = 4

var barrels = []

var overhead_array = []
var max_barrel = -1

signal move_confirmed(max_barrel : int, overhead_array : Array)

func _ready():
	_empty_overhead()
	
	barrels = get_children()
	var i = 0
	for barrel in barrels:
		barrel.id = i
		i += 1
	
func _empty_overhead():
	for i in range(N):
		if overhead_array.size() <= i:
			overhead_array.append(0)
		else:
			overhead_array[i] = 0

func _set_max_barrel(n : int):
	max_barrel = n
	for i in range(n):
		barrels[i]._open()
	for i in range(n, N):
		barrels[i]._close()
		
	if overhead_array.reduce(func(a,b): return a+b, 0) != 0:
		_confirm_move()
	
func _add_to_barrel(i : int):
	overhead_array[i] += 1
	
func _confirm_move():
	emit_signal("move_confirmed", max_barrel, overhead_array)
	_empty_overhead()
