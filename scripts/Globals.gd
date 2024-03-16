extends Node

var time_running: bool = false
var is_cutscene: bool = false
var is_tutorial: bool = false
var is_game_over: bool = true
var is_dark_mode: bool = false
var decreasingFactor: int = 1
var timeCounter: int = 300:
	set(value):
		timeCounter = value
		if is_dark_mode:
			decreasingFactor = 5
		else:
			decreasingFactor = 1
		if not is_game_over and not is_tutorial and time_running:
			gameTimer()

func gameTimer():
	await get_tree().create_timer(1).timeout
	timeCounter -= decreasingFactor
