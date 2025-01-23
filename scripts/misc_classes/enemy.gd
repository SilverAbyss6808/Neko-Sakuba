extends CharacterBody2D
class_name Enemy

static var health
static var max_health
static var min_health
static var damage
static var scene
static var speed
static var attack_type

var idle = true
var chase_player = false
var damage_player = false
var player = null

@export var time_between_idle_movements := 5.0

static var enemy_type: Dictionary = { 
	'default':['health','max_health','min_health','damage','scene','speed','attack_type'],
	'pink_slime':[5,5,0,5,preload("res://scenes/enemies/pink_slime.tscn"),50,'melee']
}

func _init() -> void:
	# SETS STATS OF BOTH PRESET AND DYNAMIC ENEMIES
	set_stats()
	print(self.type + ' spawned with health=' + str(self.health) + ', max_health=' + str(self.max_health) + ', min_health=' + str(self.min_health) + ', damage=' + str(self.damage) + ', speed=' + str(self.speed) + ', attack_type=' + self.attack_type)

func _physics_process(delta: float) -> void:
	if chase_player:
		match attack_type:
			'melee': melee_behav()
	else:
		idle_behav(delta)

static func add_enemy(type:='default',caller:Node2D=null, position=Global.player.global_position) -> Enemy:
	# ADDS NEW ENEMY FROM CODE
	var spawned_enemy = enemy_type[type][4].instantiate()
	spawned_enemy.global_position = position
	caller.add_child(spawned_enemy)
	return spawned_enemy
	
func take_damage(amount):
	sprite_flash_no_iframe()
	health -= amount
	if health < min_health:
		die()
	
func die():
	# play death animation
	queue_free()
	
func set_stats():
	self.health = enemy_type[self.type][0]
	self.max_health = enemy_type[self.type][1]
	self.min_health = enemy_type[self.type][2]
	self.damage = enemy_type[self.type][3]
	self.speed = enemy_type[self.type][5]
	self.attack_type = enemy_type[self.type][6]
	
func melee_behav():
	position += (player.position - position) / speed
	if damage_player:
		player.take_damage(damage)
		
func idle_behav(delta):
	if idle == true:
		idle = false
		
		var pos_to_change = randi_range(-1,1)
		
		var x_position = randi_range(-50,50)
		var y_position = randi_range(-50,50)
		
		match pos_to_change:
			1: move_toward_position(delta, Vector2(self.position.x + x_position, self.position.y))
			0: pass
			-1: move_toward_position(delta, Vector2(self.position.x, self.position.y + y_position))
		
		await get_tree().create_timer(time_between_idle_movements).timeout
		idle = true

func move_toward_position(delta, target_position: Vector2):
	while self.position != target_position:
		print('moving...')
		self.position = (target_position - self.position) / speed
		await get_tree().create_timer(1/speed).timeout
	print('idle movement complete.')

func sprite_flash_no_iframe():
	var flash_time = 0.05
	var orig_color := self.modulate
	for i in range(0,5):
		self.modulate = Color(1,1,1,0.1)
		await get_tree().create_timer(flash_time).timeout
		self.modulate = orig_color
		await get_tree().create_timer(flash_time).timeout
	self.modulate = orig_color

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	chase_player = true
	
func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	chase_player = false

func _on_damage_area_body_entered(body: Node2D) -> void:
	player = body
	damage_player = true
	
func _on_damage_area_body_exited(body: Node2D) -> void:
	player = null
	damage_player = false
	
