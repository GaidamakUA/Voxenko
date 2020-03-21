extends Action
class_name DeleteAction

func do(voxelHolder: VoxelHolder):
	var voxel = voxelHolder.get_voxel(position - normal/2)
	voxel.queue_free()

func undo(voxelHolder: VoxelHolder):
	print("undo ", voxelHolder)
