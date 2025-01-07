extends Area2D
class_name InteractionArea

@export var dialogue_file: DialogueResource
@export var dialogue_name: String

@onready var timer: Timer = $Timer
@onready var transition_mask: CanvasLayer = $TransitionMask
# @onready var timer_2: Timer = $Timer2

func _ready() -> void:
	transition_mask.visible = false
	
func print_test():
	print('Test')

func switch_scene(to):
	Global.set_previous_scene(Global.current_scene)
	Global.set_current_scene(to)
	print('Switch ' + str(Global.prev_scene) + ' to ' + str(Global.current_scene))
	if to != null:
		timer.start()
		fade_in()
		return # pass off to fade_in()
	else:
		print("error: no scene called")
		return

func fade_in():
	transition_mask.visible = true
	transition_mask.animation(1)
	
func fade_out():
	transition_mask.visible = true
	transition_mask.animation(2)
	
#func loading_screen():
	#transition_mask.visible = true
	#transition_mask.animation(3)

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(Global.current_scene)
	fade_out()
	# timer_2.start()

#func _on_timer_2_timeout() -> void:
	#get_tree().change_scene_to_file(Global.current_scene)
	#fade_out() # TODO: fix this

var interact: Callable = func():
	pass

func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)
	# TODO: switch to highlighted version of sprite
	
func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.deregister_area(self)
	# TODO: switch to unhighlighted version of sprite
	
func run_dialogue(local_name, default=null) -> void:
	Global.dialogue_is_running()
	if local_name != null:
		DialogueManager.show_dialogue_balloon(dialogue_file, local_name)
	else:
		DialogueManager.show_dialogue_balloon(dialogue_file, dialogue_name)
		
