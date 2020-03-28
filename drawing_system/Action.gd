extends Resource
class_name Action

export(Vector3) var position: Vector3 = Vector3.ZERO
export(Vector3) var normal: Vector3 = Vector3.UP
export(Color) var color: Color = Color.white

func do(voxelHolder):
	pass

func undo(voxelHolder):
	pass
