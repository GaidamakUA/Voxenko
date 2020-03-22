extends Control

signal action_selected(action)

var action: Action

func _ready():
	action = AddAction.new()
	action.color = Color.azure
	emit_signal("action_selected", action)

func _on_brush_selected(new_action):
	new_action.color = action.color
	action = new_action
	emit_signal("action_selected", action)


func _on_ColorPicker_color_changed(color):
	action.color = color
	emit_signal("action_selected", action)
