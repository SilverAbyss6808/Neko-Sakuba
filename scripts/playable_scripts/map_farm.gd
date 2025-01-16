extends Node2D

@onready var ground: TileMapLayer = $map/ground

func _ready() -> void:	
	Global.player.set_camera_bounds(ground)
	
	Enemy.add_enemy('pink_slime', self, Vector2(500,-250))
	
