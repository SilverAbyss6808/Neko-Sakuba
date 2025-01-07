extends CharacterBody2D

@export var speed_walk = 100.0 # export for editing from inspector
@export var speed_run = 150.0

@onready var sprite = $AnimatedSprite2D

var last_pressed_key = "s"
var can_move = true
var speed = speed_walk

func _ready():
	Global.player = self

func _physics_process(_delta):
	# variables
	var dirX = Input.get_axis("left", "right")
	var dirY = Input.get_axis("up", "down")
	
	if Input.is_action_pressed("run"):
		speed = speed_run
		sprite.speed_scale = 1.5
	else:
		speed = speed_walk
		sprite.speed_scale = 1
	
	if can_move:
		# determine speed and direction
		if dirX:
			velocity.x = dirX * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		if dirY:
			velocity.y = dirY * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
			
		## determine animation played
		if dirX == 0 && dirY == 0:
			if last_pressed_key == "s":
				sprite.play("idle_forward")
			elif last_pressed_key == "w":
				sprite.play("idle_away")
			elif last_pressed_key == "a":
				sprite.play("idle_left")
			elif last_pressed_key == "d":
				sprite.play("idle_right")
		else:
			if dirY > 0:
				sprite.play("walk_forward")
				last_pressed_key = "s"
			elif dirY < 0:
				sprite.play("walk_away")
				last_pressed_key = "w"
			elif dirX > 0:
				sprite.play("walk_right")
				last_pressed_key = "d"
			elif dirX < 0:
				sprite.play("walk_left")
				last_pressed_key = "a"
		
		# execute movement
		move_and_slide()
	else:
		if last_pressed_key == "s":
			sprite.play("idle_forward")
		elif last_pressed_key == "w":
			sprite.play("idle_away")
		elif last_pressed_key == "a":
			sprite.play("idle_left")
		elif last_pressed_key == "d":
			sprite.play("idle_right")
	
