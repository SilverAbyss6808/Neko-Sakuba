extends BaseDialogueTestScene

func _ready() -> void:
	var balloon = load('res://dialogue/dialogue_assets/balloon.tscn').instantiate()
	get_tree().current_scene.add_child.call_deferred(balloon)
	balloon.start(resource, title)
