extends Action
class_name PaintAction

func do(voxelHolder: VoxelHolder):
	var voxel = voxelHolder.get_voxel(position - normal/2)
	voxel.color = color

func undo(voxelHolder: VoxelHolder):
	print("undo ", voxelHolder)
