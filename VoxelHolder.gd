extends Spatial

onready var voxel_scene = preload("res://voxel/Voxel.tscn")
onready var editor_space = get_parent() as EditorSpace

func _unhandled_input(event):
	if event.is_action_pressed("mouse_click"):
		var voxel = voxel_scene.instance()
		voxel.translation = editor_space.cursor_position
		add_child(voxel)
