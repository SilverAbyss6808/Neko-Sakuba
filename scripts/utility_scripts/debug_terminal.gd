extends CanvasLayer

@onready var debug_terminal: CanvasLayer = $"."
@onready var margin_container: MarginContainer = $MarginContainer
@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel
@onready var text_edit: TextEdit = $MarginContainer/VBoxContainer/TextEdit

var window_size_x = DisplayServer.window_get_size().x
var window_size_y = DisplayServer.window_get_size().y
var terminal_font_size = window_size_y / 12 - 2

func _ready() -> void:
	# dynamically set layout
	debug_terminal.visible = true
	resize_terminal()
		
func _process(delta: float) -> void:
	# toggle visibility when pressed - needs changed when added UNLESS it's made a global autorun
	if Input.is_action_just_pressed("debug"):
		debug_terminal.visible = !debug_terminal.visible
	
	# handles resizing of window
	if DisplayServer.window_get_size().x != window_size_x || DisplayServer.window_get_size().y != window_size_y:
		resize_terminal()
		
func resize_terminal():
	# resize terminal (scales vbox automatically)
	margin_container.add_theme_constant_override("margin_top", 2 * (DisplayServer.window_get_size().y / 3))
	
	# reset the window dimensions
	window_size_x = DisplayServer.window_get_size().x
	window_size_y = DisplayServer.window_get_size().y
	
	# change font size
	terminal_font_size = window_size_y / 12 - 4
	rich_text_label.add_theme_font_size_override("font_size", terminal_font_size)
	text_edit.add_theme_font_size_override("font_size", terminal_font_size)
	
