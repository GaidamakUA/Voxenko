extends StaticBody
class_name Voxel

var color := Color.white setget _set_color

func _set_color(c: Color):
	color = c
	var voxel_mesh = $VoxelMesh as MeshInstance
	var material := SpatialMaterial.new()
	material.albedo_color = color
	voxel_mesh.set_surface_material(0, material)
