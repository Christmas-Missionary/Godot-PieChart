extends Resource
class_name PieChartEntryPack

@export var array_of_entries: Array[PieChartEntry]

func _init(arr: Array[PieChartEntry] = []) -> void:
	array_of_entries = arr
