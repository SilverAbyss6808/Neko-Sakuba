extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var enemy_pink_slime = $EnemyPinkSlime

func _ready() -> void:
	Global.set_current_scene("res://scenes/playable/map_farm.tscn")
	
	#var pink_slime = Enemy.new('pink_slime')
	#var slime = pink_slime.scene.instantiate()
	#var last_array_item = get_tree().root.get_children().size() - 1
	#get_tree().root.get_children()[last_array_item].add_child(slime)
	#slime.position = Vector2(500,-250)
	
	print(player.get_collision_layer_value(2))
	print(enemy_pink_slime.detection_area.get_collision_mask_value(2))
