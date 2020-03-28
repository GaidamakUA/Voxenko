extends Control

var current_file: String

var voxel_holder: VoxelHolder
onready var save_dialog = $SaveDialog
onready var open_dialog = $OpenDialog
onready var io_filters := _create_io_filters()

func _ready():
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	voxel_holder = save_nodes[0] as VoxelHolder

func _on_Save_pressed():
	if not current_file: 
		save_dialog.filters = io_filters
		save_dialog.show()
		current_file = yield($SaveDialog, "file_selected")
	_save_file(current_file)

func _on_Open_pressed():
	open_dialog.filters = io_filters
	open_dialog.show()
	var file_name: String = yield($OpenDialog, "file_selected")
	_open_file(file_name)

func _save_file(path: String):
	var strategy := _get_io_strategy_for_file(path)
	strategy.save_file(path, _get_voxels())

func _open_file(path: String):
	_clear_voxels()
		
	var strategy := _get_io_strategy_for_file(path)
	var voxel_resources: Array = strategy.open_file(path)
	
	for voxel_resource in voxel_resources:
		var voxel := voxel_resource as VoxelResource
		voxel_holder.add_voxel(voxel_resource.position, voxel_resource.colour)

func _clear_voxels():
	var voxels = _get_voxels()
	for voxel in voxels:
		voxel.queue_free()

func _get_voxels() -> Array:
	return voxel_holder.get_children()

func _get_io_strategy_for_file(path: String) -> IOStrategy:
	var lowercase_path = path.to_lower()
	var io_strategies = $IOStrategies.get_children()
	for raw_strategy in io_strategies:
		var strategy := raw_strategy as IOStrategy
		var strategy_file_type = strategy.get_file_type()
		if lowercase_path.ends_with(strategy_file_type):
			return strategy as IOStrategy
	# Should not happen
	return null

func _create_io_filters() -> PoolStringArray:
	var supported_files := PoolStringArray()
	var io_strategies = $IOStrategies.get_children()
	for raw_strategy in io_strategies:
		var strategy := raw_strategy as IOStrategy
		var file_type := strategy.get_file_type()
		var description := strategy.get_description()
		supported_files.append("*%s; %s" % [file_type, description])
	return supported_files
