extends CanvasLayer

signal retry
signal restart

@onready var timer_text: Label = $TimerDisplay/HBoxContainer/TimerDisplayText

func update_timer_text():
	var secs = fmod(Globals.timeCounter, 60)
	var mins = fmod(Globals.timeCounter, 60 * 60) / 60
	
	var time = "%02d : %02d" % [mins,secs]
	timer_text.text = time

func _on_retry_btn_pressed():
	retry.emit()

func _on_restart_pressed():
	restart.emit()
