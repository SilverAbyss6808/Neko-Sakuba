extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func animation(value: int):
	if value == 1:
		animation_player.play("fade_in")
	elif value == 2:
		animation_player.play("fade_out")
	elif value == 3:
		animation_player.play("loading_screen")	
	else:
		print("Invalid animation choose (1-3)")
