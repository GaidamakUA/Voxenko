extends Control

signal action_selected(action)

func _on_brush_selected(action):
	emit_signal("action_selected", action)
