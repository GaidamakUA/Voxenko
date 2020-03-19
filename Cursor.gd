extends Spatial

onready var editor_space = get_parent() as EditorSpace

func _on_CameraGimbal_pointing_at(cursor_position: Vector3, cursor_normal: Vector3):
	var snapped_normal = cursor_normal.snapped(Vector3.ONE)
	_move_to_collision_position(cursor_position, snapped_normal)
	if (snapped_normal.is_equal_approx(Vector3.UP)):
		look_at(translation + snapped_normal, Vector3.LEFT)
	else:
		look_at(translation + snapped_normal, Vector3.UP)

func _move_to_collision_position(cursor_position: Vector3, cursor_normal: Vector3):
	var position = cursor_position
	var displacement = _get_snap_displacement()
	position += displacement
	position = position.snapped(Vector3.ONE)
	position -= displacement
	editor_space.cursor_position = position
	translation = position - cursor_normal / 2

func _get_snap_displacement() -> Vector3:
	var displacement = Vector3()
	if editor_space.grid_width % 2 == 0:
		displacement.x = 0.5
	if editor_space.grid_height % 2 == 0:
		displacement.y = 0.5
	if editor_space.grid_depth % 2 == 0:
		displacement.z = 0.5
	return displacement 
