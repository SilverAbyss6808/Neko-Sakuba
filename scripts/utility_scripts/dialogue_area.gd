#Nathan Hoad on YouTube

extends Area2D

@export var dialogue_file: DialogueResource
@export var dialogue_name: String

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_file, dialogue_name)
