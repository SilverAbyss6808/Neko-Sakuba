extends CharacterBody2D
class_name Enemy

static var health
static var max_health
static var min_health
static var damage
static var scene
static var speed
static var attack_type

var chase_player = false
var damage_player = false
var player = null

static var enemy_type = { 
	'default':['health','max_health','min_health','damage','scene','speed','attack_type'],
	'pink_slime':[5,5,0,5,preload("res://scenes/enemies/pink_slime.tscn"),50,'melee']
}

func _init() -> void:
	set_stats()
	print(self.type + ' spawned with health=' + str(self.health) + ', max_health=' + str(self.max_health) + ', min_health=' + str(self.min_health) + ', damage=' + str(self.damage) + ', speed=' + str(self.speed) + ', attack_type=' + self.attack_type)


func _ready() -> void:
	pass
		
func _physics_process(delta: float) -> void:
	match attack_type:
		'melee': run_melee_behav()

static func add_enemy(type:='default',caller:Node2D=null, position:=Vector2(0,0)) -> Enemy:
	var spawned_enemy = enemy_type[type][4].instantiate()
	spawned_enemy.global_position = position
	caller.add_child(spawned_enemy)
	return spawned_enemy
	
func take_damage(amount):
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
	
func run_melee_behav():
	if chase_player:
		position += (player.position - position) / speed
	if damage_player:
		player.take_damage(damage)

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
	
