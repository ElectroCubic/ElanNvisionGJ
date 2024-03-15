extends CharacterBody2D

signal collided(collision)

@export var SPEED = 500.0
@export var JUMP_VELOCITY = -800.0
@export var damping_value: int = 50
@export var jumpBufferTime: float = 0.2
@export var coyoteTime: float = 0.2
var jumpBufferCounter: float
var coyoteTimeCounter: float
var jumpModifier: float = 1.4
var lowJumpMultiplier: float = 0.9
var move_speed_multiplier: float = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var animDark = $AnimatedSprite2D2

func _ready():
	DisableDarkMode()
	if Globals.is_dark_mode:
		animDark.play("Dark_Idle")
	else:
		anim.play("Idle")

func EnableDarkMode():
	Globals.is_dark_mode = true
	anim.hide()
	animDark.show()
	
func DisableDarkMode():
	Globals.is_dark_mode = false
	anim.show()
	animDark.hide()
	
func _on_world_speed_modified(multiplier):
	move_speed_multiplier = multiplier

func _physics_process(delta):

	# Add the gravity.
	if is_on_floor():
		coyoteTimeCounter = coyoteTime
	else:
		velocity.y += gravity * delta
		coyoteTimeCounter -= delta

	# Player Controls
	if (anim.animation != "Death" and animDark.animation != "Dark_Death"):
		var direction = 0
		var left = Input.is_action_pressed("Left")
		var right = Input.is_action_pressed("Right")
			
		if left and not right:
			direction = -1
			if Globals.is_dark_mode:
				animDark.flip_h = true
				if velocity.y == 0:
					animDark.play("Dark_Move")
			else:
				anim.flip_h = true
				if velocity.y == 0:
					anim.play("Move")
				
		elif right and not left:
			direction = 1
			if Globals.is_dark_mode:
				animDark.flip_h = false
				if velocity.y == 0:
					animDark.play("Dark_Move")
			else:
				anim.flip_h = false
				if velocity.y == 0:
					anim.play("Move")
		else:
			if move_speed_multiplier > 1:
				velocity.x = move_toward(velocity.x,0,1)
				if not is_on_floor():
					velocity.x = move_toward(velocity.x,SPEED,0)
			else:
				velocity.x = move_toward(velocity.x,0,SPEED)

			if velocity.y == 0:
				if Globals.is_dark_mode:
					animDark.play("Dark_Idle")
				else:	
					anim.play("Idle")
				
		if move_speed_multiplier > 1.0 and is_on_floor():
			velocity.x += direction * (SPEED/damping_value) * move_speed_multiplier
		else:
			velocity.x = direction * SPEED * move_speed_multiplier
		
		# Handle Jump.
		if Input.is_action_pressed("Jump"):
			jumpBufferCounter = jumpBufferTime
		else:
			jumpBufferCounter -= delta
		
		if Input.is_action_pressed("Jump") and coyoteTimeCounter > 0 and jumpBufferCounter > 0:
			coyoteTimeCounter = 0
			jumpBufferCounter = 0
			if Globals.is_dark_mode:
				velocity.y += JUMP_VELOCITY * jumpModifier
				animDark.play("Dark_Jump")
			else:
				velocity.y += JUMP_VELOCITY
				anim.play("Jump")

		elif velocity.y < 0 and not Input.is_action_pressed("Jump"):
			velocity.y += JUMP_VELOCITY * (lowJumpMultiplier - 1)
			
		if Input.is_action_just_pressed("SwitchPlayer"):
			$GPUParticles2D.emitting = true
			if Globals.is_dark_mode:
				DisableDarkMode()
			else:
				EnableDarkMode()
				
		# If player is mid-air
		if velocity.y > 0:
			if Globals.is_dark_mode:
				animDark.play("Dark_Fall")
			else:
				anim.play("Fall")
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		collided.emit(collision)

func hit():
	print("ded")

