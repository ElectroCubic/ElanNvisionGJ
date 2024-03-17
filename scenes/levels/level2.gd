extends World

func _on_win_area_player_touch():
	Globals.lvlSwitch = true
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level3.tscn")
