extends Area2D

signal playerTouch

func _on_body_entered(body):
	if body.name == "Player":
		playerTouch.emit()
