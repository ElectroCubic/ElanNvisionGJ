extends World

func _on_crystal_player_touch():
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/cutscene1.tscn")
