extends Node

signal timeTick
signal timeOut

var lvlSwitch: bool = false
var is_tutorial: bool = false
var is_cutscene: bool = false
var time_running = false
var is_game_over: bool = false
var is_dark_mode: bool = false
var decreasingFactor: int = 1
var timeCounter: int = 300:
	get:
		return timeCounter
	set(value):
		timeCounter = value
		timeTick.emit()

func gameTimer():
	if time_running:
		await get_tree().create_timer(1).timeout
		checkMode()
		timeCounter -= decreasingFactor
		
		if timeCounter <= 0:
			timeOut.emit()
			return
			
		gameTimer()

func checkMode():
	if is_dark_mode:
		decreasingFactor = 5
	else:
		decreasingFactor = 1
