extends Button
class_name BrushButton

signal brush_selected(action)

export(Resource) var action

func _ready():
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	emit_signal("brush_selected", action)
