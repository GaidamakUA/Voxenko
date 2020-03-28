extends IOStrategy

func get_file_type() -> String:
	return ".voxenko"

func get_description() -> String:
	return "Voxenko Files"

func save_file(file_name: String, voxels: Array):
	var save_game = File.new()
	save_game.open(file_name, File.WRITE)
	var save_data = []
	for raw_voxel in voxels:
		var voxel = raw_voxel as Voxel
		var voxel_data = Dictionary()
		voxel_data.x = voxel.translation.x
		voxel_data.y = voxel.translation.y
		voxel_data.z = voxel.translation.z
		voxel_data.colour = voxel.color.to_rgba32()
		save_data.append(voxel_data)
	save_game.store_line(to_json(save_data))
	save_game.close()

func open_file(file_name: String) -> Array:
	var output = []
	var save_game = File.new()
	save_game.open(file_name, File.READ)
	var save_data = parse_json(save_game.get_line())
	for datum in save_data:
		var voxel_resource = VoxelResource.new()
		voxel_resource.position = Vector3(datum.x, datum.y, datum.z)
		voxel_resource.colour = Color(datum.colour as int)
		output.append(voxel_resource)
	return output
