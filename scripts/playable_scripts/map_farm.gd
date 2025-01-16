extends Node2D

@onready var ground: TileMapLayer = $map/ground

func _ready() -> void:	
	Global.current_scene = self
	Global.player.set_camera_bounds(ground)
