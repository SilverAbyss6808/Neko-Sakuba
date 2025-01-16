extends Node

@onready var player

var current_scene_paused = false
var dialogue_running = false
var current_scene
var prev_scene

func _ready():
	pass

# DIALOGUE CONTROLS

func dialogue_is_running():
	dialogue_running = true
	player.can_move = false
	
func dialogue_is_done_running():
	dialogue_running = false
	player.can_move = true
	
func get_dialogue_state() -> bool:
	return dialogue_running
	
# SCENE CONTROLS 

func pause_scene():
	current_scene_paused = true
	get_tree().paused = true
		
func unpause_scene():
	current_scene_paused = false
	get_tree().paused = false
	
func set_previous_scene(scene):
	prev_scene = scene

func set_current_scene(scene):
	current_scene = scene
