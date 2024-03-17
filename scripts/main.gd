extends Node2D

func _on_play_pressed():
	Globals.is_tutorial = true
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn") 

func _on_quit_pressed():
	get_tree().quit()
