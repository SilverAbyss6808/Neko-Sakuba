extends StaticBody2D 

@onready var interaction_area: InteractionArea = $interaction_area
@onready var interaction_collision_area: CollisionShape2D = $interaction_area/interaction_collision_area

@onready var vase_full_nohighlight: Sprite2D = $vase_full_nohighlight
@onready var vase_empty_nohighlight: Sprite2D = $vase_empty_nohighlight

var empty = false
var num_ints = 0

func _ready() -> void:
	interaction_area.interact = Callable(self, '_on_interact')

func _on_interact():
	num_ints += 1
	if empty == false:
		vase_full_nohighlight.hide()
		vase_empty_nohighlight.show()
		interaction_area.run_dialogue('vase_full')
		empty = true
	elif num_ints > 5:
		interaction_area.run_dialogue('vase_really_empty')
	else:
		interaction_area.run_dialogue(null)
