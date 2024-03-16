extends Node2D

func _ready():
	Globals.is_tutorial = false
	Globals.is_cutscene = true
	$AnimationPlayer.play("cutscene1")
	$UI/TimerDisplay.visible = false
	
func changeLevel():
	Globals.is_cutscene = false
	Globals.time_running = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
