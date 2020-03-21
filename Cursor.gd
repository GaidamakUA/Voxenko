extends Spatial

func _on_CameraGimbal_pointing_at(cursor_position: Vector3, cursor_normal: Vector3):
	translation = cursor_position
	if (cursor_normal.is_equal_approx(Vector3.UP)):
		look_at(translation + cursor_normal, Vector3.LEFT)
	else:
		look_at(translation + cursor_normal, Vector3.UP)
