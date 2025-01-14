extends Node2D

@onready var player: CharacterBody2D = $Player
# @onready var enemy_pink_slime = $EnemyPinkSlime

func _ready() -> void:
	print(typeof(self))
	var pink_slime := Enemy.new_enemy('pink_slime', self, Vector2(500,-250))
	#add_child(pink_slime)
	#pink_slime.global_position = Vector2(500,-250)
	
	#print(player.get_collision_layer_value(2))
	#print(enemy_pink_slime.get_collision_mask_value(2))
