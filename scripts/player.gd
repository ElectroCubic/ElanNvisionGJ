extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -800.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("Idle")

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Player Controls
	if get_node("AnimatedSprite2D").animation != "Death":
		var direction = 0
		var left = Input.is_action_pressed("Left")
		var right = Input.is_action_pressed("Right")
			
		if left and not right:
			direction = -1
			get_node("AnimatedSprite2D").flip_h = true
			if velocity.y == 0:
				anim.play("Move")
				
		elif right and not left:
			direction = 1
			get_node("AnimatedSprite2D").flip_h = false
			if velocity.y == 0:
				anim.play("Move")
		else:
			direction = 0
			velocity.x = move_toward(velocity.x,0,SPEED)
			if velocity.y == 0:
				anim.play("Idle")
				
		velocity.x = direction * SPEED
		
		# Handle Jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y += JUMP_VELOCITY
			anim.play("Jump")
	
		# If player is mid-air
		if velocity.y > 0:
			anim.play("Fall")
	
	## Check Player's HP	
	#if Game.playerHP <= 0:
		#anim.play("Death")
		#await anim.animation_finished
		#self.queue_free()
		#get_tree().change_scene_to_file("res://main.tscn")
	
	move_and_slide()
