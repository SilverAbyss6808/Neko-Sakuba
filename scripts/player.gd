extends CharacterBody2D

#region variables
@export var speed_walk = 100.0 # export for editing from inspector
@export var speed_run = 150.0

@onready var sprite = $sprite
@onready var camera: Camera2D = $Camera2D
@onready var user_interface: CanvasLayer = $Camera2D/UserInterface
@onready var attack_radius: Area2D = $attack_radius

var last_pressed_key = "s"
var faced_direction = 'forward'
var can_move = true
var speed = speed_walk

var item_cooldown_time := 0.5
var item_on_cooldown := false
var animation_playing := false

var player_name = "Player"

var player_health = 50
var player_max_health = 100
var player_min_health = 0
var player_health_regen_multiplier = 1

var player_stamina = 50
var player_max_stamina = 100
var player_min_stamina = 0
var player_stamina_regen_multiplier = 1

var player_base_attack = 1
var player_attack_multiplier = 1
var player_base_defense = 10
var player_defense_multiplier = 1

var target_enemy = null
#endregion

func _ready():
	Global.player = self
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('use_item') && item_on_cooldown == false && animation_playing == false:
		attack()
		await play_animation('attack')

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
			play_animation('idle')
		else:
			if dirY > 0:
				faced_direction = 'forward'
			elif dirY < 0:
				faced_direction = 'away'
			elif dirX > 0:
				faced_direction = 'right'
			elif dirX < 0:
				faced_direction = 'left'
			play_animation('walk')
		# execute movement
		move_and_slide()

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
func deal_damage(target: Enemy):
	target.take_damage(player_base_attack * player_attack_multiplier)

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
	var orig_color = self.modulate
	if color == 'red':
		set_collision_layer_value(2, false)
		for i in range(0,5):
			sprite.modulate = Color(1,1,1,0.1)
			await get_tree().create_timer(flash_time).timeout
			sprite.modulate = orig_color
			await get_tree().create_timer(flash_time).timeout
		set_collision_layer_value(2, true)
		return
	if color == 'green':
		for i in range(0,5):
			sprite.modulate = Color(0,1,0,0.5)
			await get_tree().create_timer(flash_time).timeout
			sprite.modulate = Color(1,1,1)
			await get_tree().create_timer(flash_time).timeout
			flash_time -= 0.01
		return
	print('Color not red or green.')
	
func set_camera_bounds(ground_layer: TileMapLayer):
	var rectangle = ground_layer.get_used_rect()
	var tile_size = ground_layer.rendering_quadrant_size
	
	camera.limit_left = rectangle.position.x * tile_size
	camera.limit_right = rectangle.size.x * tile_size
	
	camera.limit_top = -rectangle.size.y * tile_size
	camera.limit_bottom = 0

func play_animation(type: String):
	sprite.play(str(type + '_' + faced_direction))
	#if sprite.animation_finished:
		#return

func attack():
	can_move = false
	item_on_cooldown = true
	
	if target_enemy != null:
		deal_damage(target_enemy)
		
	await get_tree().create_timer(item_cooldown_time).timeout
	can_move = true
	item_on_cooldown = false
	

func _on_attack_radius_body_entered(body: Node2D) -> void:
	target_enemy = body

func _on_attack_radius_body_exited(body: Node2D) -> void:
	target_enemy = null

func _on_sprite_animation_finished() -> void:
	print('animation_finished signal emitted')
