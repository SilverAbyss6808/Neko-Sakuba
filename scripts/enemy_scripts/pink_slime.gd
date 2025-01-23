extends Enemy

@onready var slime: CharacterBody2D = $"."
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var type = 'pink_slime'
	
#func _process(delta: float) -> void:
	#if slime.chase_player == true:
		#sprite.speed_scale = 1.5
	#else:
		#sprite.speed_scale = 1
