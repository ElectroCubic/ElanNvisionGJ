extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -800.0
var move_speed_multiplier: float = 1.0
var damping_value: int = 50
var DARK_MODE: bool = false

signal collided(collision)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var animDark = $AnimatedSprite2D2

func EnableDarkMode():
	DARK_MODE = true
	anim.hide()
	animDark.show()
	
func DisableDarkMode():
	DARK_MODE = false
	anim.show()
	animDark.hide()

func _ready():
	#EnableDarkMode()
	DisableDarkMode()
	if DARK_MODE:
		animDark.play("Dark_Idle")
	else:
		anim.play("Idle")

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Player Controls
	if (anim.animation != "Death" and animDark.animation != "Dark_Death"):
		var direction = 0
		var left = Input.is_action_pressed("Left")
		var right = Input.is_action_pressed("Right")
			
		if left and not right:
			direction = -1
			if DARK_MODE:
				animDark.flip_h = true
				if velocity.y == 0:
					animDark.play("Dark_Move")
			else:
				anim.flip_h = true
				if velocity.y == 0:
					anim.play("Move")
				
		elif right and not left:
			direction = 1
			if DARK_MODE:
				animDark.flip_h = false
				if velocity.y == 0:
					animDark.play("Dark_Move")
			else:
				anim.flip_h = false
				if velocity.y == 0:
					anim.play("Move")
		else:
			direction = 0
			velocity.x = move_toward(velocity.x,0,SPEED)
			if velocity.y == 0:
				if DARK_MODE:
					animDark.play("Dark_Idle")
				else:	
					anim.play("Idle")
				
		if move_speed_multiplier > 1.0:
			velocity.x += direction * (SPEED/damping_value) * move_speed_multiplier
		else:
			velocity.x = direction * SPEED * move_speed_multiplier
		
		# Handle Jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y += JUMP_VELOCITY
			if DARK_MODE:
				animDark.play("Dark_Jump")
			else:
				anim.play("Jump")
	
		# If player is mid-air
		if velocity.y > 0:
			if DARK_MODE:
				animDark.play("Dark_Fall")
			else:
				anim.play("Fall")
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		collided.emit(collision)


func hit():
	print("ded")

func _on_world_speed_modified(multiplier):
	move_speed_multiplier = multiplier
