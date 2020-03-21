extends StaticBody
class_name Voxel
	
func set_color(color: Color):
	var voxel_mesh = $VoxelMesh as MeshInstance
	var material := SpatialMaterial.new()
	material.albedo_color = color
	voxel_mesh.set_surface_material(0, material)
