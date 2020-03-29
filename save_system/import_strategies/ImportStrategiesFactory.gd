extends Node

class_name ImportStrategiesFactory

onready var filters := _create_filters()

func get_strategy_for_file(path: String) -> ImportStrategy:
	var lowercase_path = path.to_lower()
	var strategies = get_children()
	for raw_strategy in strategies:
		var strategy := raw_strategy as ImportStrategy
		var strategy_file_type = strategy.get_file_type()
		if lowercase_path.ends_with(strategy_file_type):
			return strategy as ImportStrategy
	# Should not happen
	return null

func _create_filters() -> PoolStringArray:
	var supported_files := PoolStringArray()
	var strategies = get_children()
	for raw_strategy in strategies:
		var strategy := raw_strategy as ImportStrategy
		var file_type := strategy.get_file_type()
		var description := strategy.get_description()
		supported_files.append("*%s; %s" % [file_type, description])
	return supported_files
