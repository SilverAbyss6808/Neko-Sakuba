extends CharacterBody2D

@export var speed_walk = 100.0 # export for editing from inspector
@export var speed_run = 150.0

@onready var sprite = $AnimatedSprite2D
@onready var user_interface: CanvasLayer = $Camera2D/UserInterface

var last_pressed_key = "s"
var can_move = true
var speed = speed_walk

var player_name = "Player"

var player_health = 50
var player_max_health = 100
var player_min_health = 0
var player_health_regen_multiplier = 1

var player_stamina = 50
var player_max_stamina = 100
var player_min_stamina = 0
var player_stamina_regen_multiplier = 1

var player_base_attack = 10
var player_attack_multiplier = 1
var player_base_defense = 10
var player_defense_multiplier = 1

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

func take_damage(damage_amount):
	#if typeof(damage_amount) == TYPE_INT || typeof(damage_amount) == TYPE_FLOAT:
	player_health -= damage_amount
	user_interface.update_ui()
	sprite_flash('red') # INCLUDES IFRAMES
	if player_health <= player_min_health:
		player_die()
	#else:
		#print('Damage not an integer or float.')

# TODO: fill in once enemy class declared
func deal_damage(target, damage_amount):
	pass

func heal_damage(heal_amount):
	player_health += heal_amount
	user_interface.update_ui()
	sprite_flash('green')
	if player_health >= player_max_health:
		player_health = player_max_health
		
# TODO: show death screen, then reload last save
func player_die():
	print('You died!')
	
func lose_stamina(amt):
	player_stamina -= amt
	user_interface.update_ui()
	
func regen_stamina():
	while player_stamina < player_max_stamina:
		player_stamina += player_stamina_regen_multiplier
		user_interface.update_ui()
		
func sprite_flash(color):
	var flash_time = 0.05
	if color == 'red':
		set_collision_layer_value(2, false)
		for i in range(0,5):
			sprite.modulate = Color(1,0,0,0.5)
			await get_tree().create_timer(flash_time).timeout
			sprite.modulate = Color(1,1,1)
			await get_tree().create_timer(flash_time).timeout
		set_collision_layer_value(2, true)
		return
	if color == 'green':
		for i in range(0,5):
			sprite.modulate = Color(0,1,0,0.5)
			await get_tree().create_timer(flash_time).timeout
			sprite.modulate = Color(1,1,1)
			await get_tree().create_timer(flash_time).timeout
		return
	print('Color not red or green.')
