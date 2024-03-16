extends World

func _on_area_2d_player_touch():
	Globals.time_running = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/level2.tscn")
