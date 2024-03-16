extends Area2D

func turnOff():
	$PointLight2D.energy = 0
	$AnimatedSprite2D.play("TorchOff")
	
func turnOn():
	$PointLight2D.energy = 0.84
	$AnimatedSprite2D.play("TorchOn")

func _ready():
	$PointLight2D.energy = 0

func _on_body_entered(body):
	if body.name == "Player" and not Globals.is_cutscene:
		turnOn()
