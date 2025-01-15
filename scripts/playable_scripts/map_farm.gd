extends Node2D



func _ready() -> void:
	Enemy.new_enemy('pink_slime', self, Vector2(500,-250))
	
