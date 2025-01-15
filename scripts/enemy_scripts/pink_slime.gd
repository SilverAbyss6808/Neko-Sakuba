extends Enemy

@onready var slime: CharacterBody2D = $"."
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if slime.chase_player == true:
		sprite.speed_scale = 1.5
	else:
		sprite.speed_scale = 1
		#idle_behav()
		#
#func idle_behav():
	#slime.position = Vector2(position.x + randi_range(-10,10), position.y + randi_range(-10,10))
	#await get_tree().create_timer(5).timeout
