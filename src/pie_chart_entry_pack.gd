class_name PieChartEntryPack extends Resource
## A wrapper for an array of [PieChartEntry] resources for when you want to save as one resource in [code]res://[/code].

## The array of entries in question.
@export var array_of_entries: Array[PieChartEntry] = []

func _init(arr: Array[PieChartEntry] = []) -> void:
	array_of_entries = arr
