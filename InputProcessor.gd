extends Node

signal action_called(action)

onready var voxelHolder := get_parent().find_node("VoxelHolder") as VoxelHolder
var _position: Vector3
var _normal: Vector3
var _selected_action

func _unhandled_input(event):
	if event.is_action_pressed("mouse_click"):
		_selected_action.position = _position
		_selected_action.normal = _normal
		_selected_action.color = Color.green
		emit_signal("action_called", _selected_action)

func _on_CameraGimbal_pointing_at(position: Vector3, normal: Vector3):
	_position = position
	_normal = normal

func _on_BrushPicker_action_selected(action):
	print("action ", action)
	_selected_action = action
