extends Control

@onready var _sub_one: PieChart = PieChart.new()

func _ready() -> void:
	_sub_one.entries_array = [PieChartEntry.new("Test", 1)]
	$Container.add_child(_sub_one)
	_sub_one.name = &"Subject1"
