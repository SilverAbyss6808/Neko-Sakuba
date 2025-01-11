extends CanvasLayer

@onready var health_label: Label = $VBoxContainer/HealthLabel
@onready var stamina_label: Label = $VBoxContainer/StaminaLabel
@onready var player: CharacterBody2D = $"../.."

var ui_text_size
var window_size_y = DisplayServer.window_get_size().y

func _ready() -> void:
	update_ui()
	adjust_text_size()
	
func _process(delta: float) -> void:
	if DisplayServer.window_get_size().y != window_size_y:
		adjust_text_size()
	
func adjust_text_size():
	ui_text_size = window_size_y / 15
	window_size_y = DisplayServer.window_get_size().y
	
	health_label.add_theme_font_size_override('font_size', ui_text_size)
	stamina_label.add_theme_font_size_override('font_size', ui_text_size)
	
func update_ui():
	health_label.text = 'Health: ' + str(player.player_health) + '/' + str(player.player_max_health)
	stamina_label.text = 'Stamina: ' + str(player.player_stamina) + '/' + str(player.player_max_stamina)
