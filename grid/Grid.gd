tool
extends Spatial

class_name Grid

export(int, 1, 50) var grid_width := 5 setget _width_updated
export(int, 1, 50) var grid_height := 5 setget _height_updated
export(int, 1, 50) var grid_depth := 5 setget _depth_updated

func _width_updated(width: int):
	grid_width = width
	_update_grid()
	
func _height_updated(height: int):
	grid_height = height
	_update_grid()

func _depth_updated(depth: int):
	grid_depth = depth
	_update_grid()
	
func _update_grid():
	var face_depth = $FaceDepth
	face_depth.translation = Vector3.FORWARD * (grid_depth / 2.0)
	face_depth.grid_height = grid_height
	face_depth.grid_width = grid_width
	var face_width = $FaceWidth
	face_width.translation = Vector3.LEFT * (grid_width / 2.0)
	face_width.grid_height = grid_height
	face_width.grid_width = grid_depth
	var face_heigh = $FaceHeight
	face_heigh.translation = Vector3.DOWN * (grid_height / 2.0)
	face_heigh.grid_height = grid_depth
	face_heigh.grid_width = grid_width


func _on_CameraGimbal_camera_moved(new_position: Vector3):
	scale = new_position.sign()
