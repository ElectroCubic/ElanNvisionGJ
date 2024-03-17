extends Node2D

func playClickSound():
	$"Audio Manager/SceneChange".play()

func _on_play_pressed():
	playClickSound()
	await get_tree().create_timer(1).timeout
	Globals.is_tutorial = true
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn") 

func _on_quit_pressed():
	playClickSound()
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func _on_main_menu_finished():
	$"Audio Manager/Main Menu".play()
