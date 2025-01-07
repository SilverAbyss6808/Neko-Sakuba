extends StaticBody2D

@onready var interaction_area: InteractionArea = $interaction_area
@onready var collision_shape_2d: CollisionShape2D = $interaction_area/CollisionShape2D


func _ready() -> void:
	interaction_area.interact = Callable(self, '_on_interact')

func _on_interact():
	interaction_area.switch_scene("res://scenes/playable/playable_bedroom.tscn")
