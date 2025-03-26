extends Control

func _ready() -> void:
	PieChart.new_with_labels(3, true).with_parent_as(self).set_up_labels(
		[PieChartEntry.new("Green", 2, Color.GREEN), PieChartEntry.new("Red", 3, Color.RED)],
		["%n\n%p%w", "%n\n%p%w"]
	)
