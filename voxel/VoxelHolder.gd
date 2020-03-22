extends Spatial
class_name VoxelHolder

onready var voxel_scene = preload("res://voxel/Voxel.tscn")

func _on_InputProcessor_action_called(action: Action):
	action.do(self)

func add_voxel(position: Vector3, color: Color):
	var voxel := voxel_scene.instance() as Voxel
	voxel.translation = position
	voxel.color = color
	add_child(voxel)

func get_voxel(position: Vector3) -> Voxel:
	for child in get_children():
		if(position.is_equal_approx(child.translation)):
			return child
	return null
