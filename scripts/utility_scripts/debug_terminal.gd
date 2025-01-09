extends CanvasLayer

@onready var debug_terminal: CanvasLayer = $"."
@onready var margin_container: MarginContainer = $MarginContainer
@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var line_edit: LineEdit = $MarginContainer/VBoxContainer/LineEdit

var window_size_x = DisplayServer.window_get_size().x
var window_size_y = DisplayServer.window_get_size().y
var terminal_font_size = window_size_y / 12 - 8
var previous_entries: Array

func _ready() -> void:
	# connect to text submission stuff
	line_edit.text_submitted.connect(self._on_text_submitted)
	
	# dynamically set layout
	debug_terminal.visible = true
	line_edit.editable = true
	line_edit.grab_focus()
	resize_terminal()
		
func _process(delta: float) -> void:
	# toggle visibility when pressed - needs changed when added UNLESS it's made a global autorun
	if Input.is_action_just_pressed("debug"):
		debug_terminal.visible = !debug_terminal.visible
		line_edit.editable = !line_edit.editable
		if debug_terminal.visible == true:
			line_edit.clear()
			line_edit.grab_focus()
	
	# handles resizing of window
	if DisplayServer.window_get_size().x != window_size_x || DisplayServer.window_get_size().y != window_size_y:
		resize_terminal()
		
func _on_text_submitted(command):
	var expression = Expression.new()
	var error = expression.parse(command)
	
	if error != OK:
		update_console('ERROR: ' + expression.get_error_text())
		return
		
	var result = expression.execute()
	
	if expression.has_execute_failed() == false:
		update_console(str(result))
	else:
		update_console('Execution failed.')
		
		
func resize_terminal():
	# resize terminal (scales vbox automatically)
	margin_container.add_theme_constant_override("margin_top", 2 * (DisplayServer.window_get_size().y / 3))
	
	# reset the window dimensions
	window_size_x = DisplayServer.window_get_size().x
	window_size_y = DisplayServer.window_get_size().y
	
	# change font size
	terminal_font_size = window_size_y / 12 - 8
	label.add_theme_font_size_override("font_size", terminal_font_size)
	line_edit.add_theme_font_size_override("font_size", terminal_font_size)
	
func update_console(string):
	label.text = label.text + '\n' + string
	line_edit.clear()
