extends Node2D

func _ready():
	var manager = $Manager as GameManager
	$Manager.chance_agent_p = GlobalManager.difficulty
