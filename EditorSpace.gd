extends Spatial

func _ready():
	var grid = $Grid
	var displacement = Vector3(grid.grid_width, grid.grid_height, grid.grid_width) / 2
	var zero_voxel_position = Vector3.ONE / 2
	$CameraGimbal.translation = displacement - zero_voxel_position
	$Grid.translation = displacement - zero_voxel_position
