extends Node

var is_dark_mode: bool = false
var decreasingFactor: int = 1
var timeCounter: int = 600:
	set(value):
		timeCounter = value
		if is_dark_mode:
			decreasingFactor = 5
		else:
			decreasingFactor = 1
		gameTimer()

func gameTimer():
	await get_tree().create_timer(1).timeout
	timeCounter -= decreasingFactor
