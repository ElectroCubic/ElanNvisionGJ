extends Area2D

func _ready():
	$SelfDestructTimer.start()

func _process(_delta):
	rotation += 0.01
	position.y += 5

func _on_body_entered(body):
	if body.name == "Player":
		body.hit()

func _on_self_destruct_timer_timeout():
	queue_free()
