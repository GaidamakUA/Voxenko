extends Action
class_name AddAction

func do(voxelHolder: VoxelHolder):
	voxelHolder.add_voxel(position + normal / 2, color)

func undo(voxelHolder: VoxelHolder):
	print("undo ", voxelHolder)
