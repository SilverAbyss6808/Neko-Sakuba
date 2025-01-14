extends CharacterBody2D
class_name Enemy

var health
var max_health
var min_health
var damage
var scene
var speed

var chase_player = false
var damage_player = false
var player = null

var enemy_type = { 
	'pink_slime':[5,5,0,1,preload("res://scenes/enemies/enemy_pink_slime.tscn"),50]
}

func _ready() -> void:
	# spawn_enemy('pink_slime', Vector2(500,-250))
	pass
	
func _physics_process(delta: float) -> void:
	if chase_player:
		position += (player.position - position) / speed
		print('chasing player')
	if damage_player: # && typeof(damage) == TYPE_INT:
		player.take_damage(damage)
		print('damaging player')

func _init(type) -> void:
	
	health = enemy_type[type][0]
	max_health = enemy_type[type][1]
	min_health = enemy_type[type][2]
	damage = enemy_type[type][3]
	scene = enemy_type[type][4]
	speed = enemy_type[type][5]
	
	print(type + ' spawned with health=' + str(health) + ', max_health=' + str(max_health) + ', min_health=' + str(min_health) + ', damage=' + str(damage) + ', speed=' + str(speed))
	
func take_damage(amount):
	health -= amount
	if health < min_health:
		die()
	
func die():
	# play death animation
	get_tree().queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	print('detection body entered')
	player = body
	chase_player = true
	
func _on_detection_area_body_exited(body: Node2D) -> void:
	print('detection body exited')
	player = null
	chase_player = false

func _on_damage_area_body_entered(body: Node2D) -> void:
	print('damage body entered')
	player = body
	damage_player = true
	
func _on_damage_area_body_exited(body: Node2D) -> void:
	print('damage body exited')
	player = null
	damage_player = false
	
