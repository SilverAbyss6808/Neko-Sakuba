extends CharacterBody2D
class_name Enemy

static var health
static var max_health
static var min_health
static var damage
static var scene
static var speed

var chase_player = false
var damage_player = false
var player = null

static var enemy_type = { 
	'default':[0,0,0,0,0,0],
	'pink_slime':[5,5,0,1,preload("res://scenes/enemies/enemy_pink_slime.tscn"),50]
}

func _ready() -> void:
	# spawn_enemy('pink_slime', Vector2(500,-250))
	pass
	
func _physics_process(delta: float) -> void:
	if chase_player:
		position += (player.position - position) / speed
	if damage_player:
		player.take_damage(damage)

static func new_enemy(type:='default',caller:Node2D=null, position:=Vector2(0,0)) -> Enemy:
	
	var spawned_enemy = enemy_type[type][4].instantiate()

	spawned_enemy.health = enemy_type[type][0]
	spawned_enemy.max_health = enemy_type[type][1]
	spawned_enemy.min_health = enemy_type[type][2]
	spawned_enemy.damage = enemy_type[type][3]
	spawned_enemy.scene = enemy_type[type][4]
	spawned_enemy.speed = enemy_type[type][5]

	print(type + ' spawned with health=' + str(health) + ', max_health=' + str(max_health) + ', min_health=' + str(min_health) + ', damage=' + str(damage) + ', speed=' + str(speed))
	
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
	
