extends StaticBody2D 

@onready var interaction_area: InteractionArea = $interaction_area
@onready var collision_shape_2d: CollisionShape2D = $interaction_area/CollisionShape2D

var num_ints = 0

func _ready() -> void:
	interaction_area.interact = Callable(self, '_on_interact')

func _on_interact():
	num_ints += 1
	if num_ints > 1:
		interaction_area.run_dialogue(null)
	else:
		interaction_area.run_dialogue('tree_first')
