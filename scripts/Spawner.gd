extends Node2D

var snowBall = preload("res://scenes/Objects/snow_ball.tscn")

func _on_snow_ball_spawner_timeout():
	for temp in get_children():
		if temp.is_in_group("Spawner"):
			var tempPos = temp.global_position
			var tempSnowBall = snowBall.instantiate()
			tempSnowBall.position = tempPos
			add_child(tempSnowBall)
