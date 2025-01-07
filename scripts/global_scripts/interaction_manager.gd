#most of script from DashNothing on YouTube, with minor changes

extends Node2D

@onready var label: Label = $NinePatchRect/dialogue_text
@onready var box: NinePatchRect = $NinePatchRect

var active_areas = []
var can_interact = true

func _process(_delta):
	if Global.get_dialogue_state() == false:
		can_interact = true
		
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		box.global_position.x = active_areas[0].global_position.x - box.size.x / 2
		box.global_position.y = active_areas[0].global_position.y - 50
		label.global_position.x = box.global_position.x + 1
		label.global_position.y = box.global_position.y + 2
		box.show()
		label.show()
	else:
		box.hide()
		label.hide()
		
func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func deregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = Global.player.global_position.distance_to(area1.global_position)
	var area2_to_player = Global.player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			box.hide()
			label.hide()
			await active_areas[0].interact.call()
