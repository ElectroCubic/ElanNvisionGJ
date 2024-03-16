extends World

func _on_crystal_player_touch():
	Globals.is_cutscene = true
	get_tree().call_deferred("change_scene_to_file", "res://scenes/cutscene1.tscn")
