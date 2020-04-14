extends Control

var current_file: String

var voxel_holder: VoxelHolder
onready var save_dialog = $SaveDialog
onready var open_dialog = $OpenDialog
onready var io_strategies_factory := $IOStrategiesFactory as IOStrategiesFactory
onready var import_strategies_factory := $ImportStrategiesFactory as ImportStrategiesFactory
onready var export_strategies_factory := $ExportStrategiesFactory as ExportStrategiesFactory

func _ready():
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	voxel_holder = save_nodes[0] as VoxelHolder

func _on_Save_pressed():
	if not current_file: 
		save_dialog.filters = io_strategies_factory.filters
		save_dialog.show()
		current_file = yield($SaveDialog, "file_selected")
	_save_file(current_file)

func _on_Open_pressed():
	open_dialog.filters = io_strategies_factory.filters
	open_dialog.show()
	var file_name: String = yield($OpenDialog, "file_selected")
	_open_file(file_name)

func _on_Import_pressed():
	open_dialog.filters = import_strategies_factory.filters
	open_dialog.show()
	var file_name: String = yield($OpenDialog, "file_selected")
	_import_file(file_name)

func _on_Export_pressed():
	save_dialog.filters = export_strategies_factory.filters
	save_dialog.show()
	current_file = yield($SaveDialog, "file_selected")
	_export_file(current_file)
	
func _save_file(path: String):
	var strategy := io_strategies_factory.get_strategy_for_file(path)
	strategy.save_file(path, _get_voxels())

func _export_file(path: String):
	var strategy := export_strategies_factory.get_strategy_for_file(path)
	strategy.save_file(path, _get_voxels())

func _open_file(path: String):
	var strategy := io_strategies_factory.get_strategy_for_file(path)
	var voxel_resources: Array = strategy.open_file(path)
	_show_loaded_voxels(voxel_resources)

func _import_file(path: String):
	var strategy := import_strategies_factory.get_strategy_for_file(path)
	var voxel_resources: Array = strategy.open_file(path)
	_show_loaded_voxels(voxel_resources)

func _show_loaded_voxels(voxel_resources: Array):
	_clear_voxels()
	for voxel_resource in voxel_resources:
		var voxel := voxel_resource as VoxelResource
		voxel_holder.add_voxel(voxel_resource.position, voxel_resource.colour)

func _clear_voxels():
	var voxels = _get_voxels()
	for voxel in voxels:
		voxel.queue_free()

func _get_voxels() -> Array:
	return voxel_holder.get_children()
