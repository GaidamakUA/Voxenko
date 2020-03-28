extends Node
class_name IOStrategy

func get_file_type() -> String:
	return ""

func get_description() -> String:
	return ""

func save_file(file_name: String, voxels: Array):
	pass

func open_file(file_name: String) -> Array:
	return []
