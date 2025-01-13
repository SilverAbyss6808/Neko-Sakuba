extends Node2D

func _ready() -> void:
	Global.set_current_scene("res://scenes/playable/map_farm.tscn")
	
	var pink_slime: Node = Enemy.new('pink_slime', Vector2(500,-250))
	var slime1 = pink_slime.scene.instantiate()
	get_tree().root.get_children()[0].add_child(slime1)
	slime1.position = Vector2(500,-250)
