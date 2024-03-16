extends Area2D

func _ready():
	$PointLight2D.energy = 0

func _on_body_entered(body):
	if body.name == "Player":
		$PointLight2D.energy = 0.84
		$AnimatedSprite2D.play("TorchOn")
