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

func playJumpSound():
	$JumpSound.play()

func playTransformSound():
	$TransformSound.play()

func makeScared():
	anim.play("Scared")
	
func makeAngry():
	anim.play("Angry")
	
func makeNormal():
	anim.play("Idle")

func charFlip():
	anim.flip_h = not anim.flip_h

func charMoveLeft():
	if Globals.is_dark_mode:
		animDark.flip_h = true
		if velocity.y == 0:
			animDark.play("Dark_Move")
	else:
		anim.flip_h = true
		if velocity.y == 0:
			anim.play("Move")
			
func charMoveRight():
	if Globals.is_dark_mode:
		animDark.flip_h = false
		if velocity.y == 0:
			animDark.play("Dark_Move")
	else:
		anim.flip_h = false
		if velocity.y == 0:
			anim.play("Move")

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

func emitWalkParticles():
	$WalkParticles.emitting = true
	
func stopWalkParticles():
	$WalkParticles.emitting = false

func _physics_process(delta):

	# Add the gravity.
	if is_on_floor():
		coyoteTimeCounter = coyoteTime
	else:
		velocity.y += gravity * delta
		coyoteTimeCounter -= delta

	# Player Controls
	if (anim.animation != "Death" and animDark.animation != "Dark_Death") and not Globals.is_cutscene and not Globals.is_game_over:
		var direction = 0
		var left = Input.is_action_pressed("Left")
		var right = Input.is_action_pressed("Right")
		
		if velocity and is_on_floor() and not move_speed_multiplier > 1:
			if $WalkTimer.time_left <= 0:
				$WalkSound.pitch_scale = randf_range(0.8,1.2)
				$WalkSound.play()
				$WalkTimer.start(0.2)
			emitWalkParticles()
		else:
			stopWalkParticles()

			
		if left and not right:
			direction = -1
			charMoveLeft()
				
		elif right and not left:
			direction = 1
			charMoveRight()
		else:
			if move_speed_multiplier > 1:
				if $SlideTimer.time_left <= 0 and not velocity.x == 0:
					$SlideSound.play()
					$SlideTimer.start(0.5)
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
			playJumpSound()
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
			
		if Input.is_action_just_pressed("SwitchPlayer") and Globals.time_running:
			playTransformSound()
			$ChangeParticles.emitting = true
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

func death():
	if not $DeathSound.playing and not Globals.is_game_over:
		$DeathSound.play()
	Globals.is_game_over = true
	Globals.time_running = false
	
	if Globals.is_dark_mode:
		animDark.play("Dark_Death")
		await get_tree().create_timer(0.5).timeout
		animDark.hide()
	else:
		anim.play("Death")
		await get_tree().create_timer(0.5).timeout
		anim.hide()
	
	velocity = Vector2.ZERO
	$DeathParticles.emitting = true
	await get_tree().create_timer(1).timeout
	$"../UI/GameOverScreen".visible = true
