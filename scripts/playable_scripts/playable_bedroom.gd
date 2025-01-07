extends Node2D

@onready var interaction_area: InteractionArea = $interaction_area

func _ready() -> void:
	Global.set_current_scene("res://scenes/playable/playable_bedroom.tscn")
	interaction_area.interact = Callable(self, '_on_interact')
	
func _on_interact():
	interaction_area.switch_scene("res://scenes/playable/playable_outside.tscn")
	
