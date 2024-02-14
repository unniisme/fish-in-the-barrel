extends Node2D

func play(name):
	find_child(name).play()

func stop():
	for child in get_children():
		child.stop()
