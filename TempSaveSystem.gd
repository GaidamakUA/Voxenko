extends HBoxContainer

signal get_save_data(save_system)

func _on_Save_pressed():
	pass

func _on_SaveDialog_file_selected(path):
	var save_game = File.new()
	save_game.open(path, File.WRITE)
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var voxel_holder := save_nodes[0] as VoxelHolder
	var voxels = voxel_holder.get_children()
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


func _on_LoadDialog_file_selected(path):
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var voxel_holder := save_nodes[0] as VoxelHolder
	var voxels = voxel_holder.get_children()
	for voxel in voxels:
		voxel.queue_free()
	
	var save_game = File.new()
	save_game.open(path, File.READ)
	var save_data = parse_json(save_game.get_line())
	for datum in save_data:
		var position := Vector3(datum.x, datum.y, datum.z)
		var colour := Color(datum.colour as int)
		voxel_holder.add_voxel(position, colour)
