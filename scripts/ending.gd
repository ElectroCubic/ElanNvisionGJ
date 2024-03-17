extends Node2D

func _ready():
	Globals.is_cutscene = true
	$UI/TimerDisplay.visible = false
	Globals.time_running = false
	$AnimationPlayer.play("cutscene2")
	
func displayBtns():
	$UI/Congrats.visible = true
	$AudioStreamPlayer.play()
	
func dyingSound():
	$DieSound.play()
