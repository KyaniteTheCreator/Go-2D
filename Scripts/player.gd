class_name Player
extends CharacterBody2D

@export var speed := 400
@export var jump_force := 300
@export var gravity := 800
@export var max_jumps := 2
@export var wall_jump_force_x := 250
@export var wall_jump_force_y := 255

var jumps_left := max_jumps
var wall_jump_timer := 0.0

var spawning := true
var dying := false

var lives := 3
var spawn_position : Vector2

var fly_mode = false

func jump():
	velocity.y = -jump_force

func jump_side(x):
	velocity.y = -jump_force
	velocity.x = x

func _ready():

	spawn_position = global_position

	$AnimatedSprite2D.play("Appear")
	await $AnimatedSprite2D.animation_finished

	spawning = false

func die():
	if dying:
		return

	dying = true

	GameController.reset_coins()

	for coin in get_tree().get_nodes_in_group("Coins"):
		print("Found:", coin.name)
		if coin.has_method("reset_coin"):
			coin.reset_coin()

	global_position = spawn_position
	velocity = Vector2.ZERO

	$AnimatedSprite2D.play("Appear")
	await $AnimatedSprite2D.animation_finished

	dying = false

	if lives <= 0 and !fly_mode:
		die()
		
	global_position = spawn_position
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("Appear")
	await $AnimatedSprite2D.animation_finished

	dying = false


func _physics_process(delta):
	if spawning or dying:
		return

	if global_position.y > 1000:
		die()

	wall_jump_timer -= delta
	var direction = Input.get_axis("Left", "Right")

	if Input.is_action_just_pressed("Hack"):
		fly_mode = !fly_mode

	if fly_mode:
		velocity.y = 0

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Reset jumps
	if is_on_floor():
		jumps_left = max_jumps

	# Movement
	velocity.x = direction * speed

	# Normal jump + double jump
	if Input.is_action_just_pressed("Jump") and jumps_left > 0:

		jumps_left -= 1
		velocity.y = -jump_force

		if jumps_left == 1:
			$AnimatedSprite2D.play("Jump")
		else:
			$AnimatedSprite2D.play("DoubleJump")

	# Wall jump
	if is_on_wall() and not is_on_floor() and Input.is_action_just_pressed("Jump"):

		var wall_dir = get_wall_normal().x

		velocity.x = wall_dir * wall_jump_force_x
		velocity.y = -wall_jump_force_y

		wall_jump_timer = 0.2
		$AnimatedSprite2D.play("WallJump")


	# Facing direction
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true


	# Animation logic
	if wall_jump_timer > 0:
		$AnimatedSprite2D.play("WallJump")


	elif $AnimatedSprite2D.animation == "DoubleJump" and $AnimatedSprite2D.is_playing():
		pass


	elif velocity.y < -20:
		$AnimatedSprite2D.play("Jump")


	elif velocity.y > 50:
		$AnimatedSprite2D.play("Fall")


	elif direction != 0:
		$AnimatedSprite2D.play("Run")


	else:
		$AnimatedSprite2D.play("Idle")


	# Run offset
	if $AnimatedSprite2D.animation == "Run":
		$AnimatedSprite2D.offset.y = 4
	else:
		$AnimatedSprite2D.offset.y = 0

	if fly_mode:
		velocity = Vector2.ZERO

		if Input.is_action_pressed("Left"):
			velocity.x = -400

		if Input.is_action_pressed("Right"):
			velocity.x = 400

		if Input.is_action_pressed("Jump"): # jump key
			velocity.y = -400

		if Input.is_action_pressed("Down"):
			velocity.y = 400

	move_and_slide()


func _on_resume_pressed() -> void:
	pass # Replace with function body.
