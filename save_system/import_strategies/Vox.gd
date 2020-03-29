extends ImportStrategy

func get_file_type() -> String:
	return ".vox"

func get_description() -> String:
	return "MagicVoxel Files"

func open_file(file_name: String) -> Array:
	var file = File.new()
	file.open(file_name, File.READ)

	var identifier = PoolByteArray([ file.get_8(), file.get_8(), file.get_8(), file.get_8() ]).get_string_from_ascii()
	var version = file.get_32()
	var voxels = {}
	var colors = null
	var sizeX = 0
	var sizeY = 0
	var sizeZ = 0

	if identifier == 'VOX ':
		while file.get_position() < file.get_len():
			var chunkId = PoolByteArray([ file.get_8(), file.get_8(), file.get_8(), file.get_8() ]).get_string_from_ascii()
			var chunkSize = file.get_32()
			var childChunks = file.get_32()

			match chunkId:
				'SIZE':
					sizeX = file.get_32()
					sizeY = file.get_32()
					sizeZ = file.get_32()
					print('size: ', sizeX, ', ', sizeY, ', ', sizeZ)
					file.get_buffer(chunkSize - 4 * 3)
				'XYZI':
					for i in range(file.get_32()):
						var x = file.get_8()
						var z = file.get_8()
						var y = file.get_8()
						var c = file.get_8()
						var voxel = Vector3(x, y, z)
						voxels[voxel] = c - 1
				'RGBA':
					colors = []
					for i in range(256):
						var r = float(file.get_8() / 255.0)
						var g = float(file.get_8() / 255.0)
						var b = float(file.get_8() / 255.0)
						var a = float(file.get_8() / 255.0)
						colors.append(Color(r, g, b, a))
				_:
						file.get_buffer(chunkSize)
		
		if voxels.size() == 0: return voxels
	file.close()

	var output = []
	for raw_voxel in voxels:
		var voxel := VoxelResource.new()
		voxel.position = raw_voxel
		voxel.colour = colors[voxels[raw_voxel]]
		output.append(voxel)
	
	return output
