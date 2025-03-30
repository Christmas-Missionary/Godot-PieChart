extends Node2D

func _draw() -> void:
	var parent: PieChartTitleLabel = get_parent() as PieChartTitleLabel
	assert(parent, "Parent is not a PieChartTitleLabel! You are not supposed to assign this script to a child of a non-PieChartTitleLabel!")
	draw_circle(parent.size / 2, parent.circle_radius, parent.circle_color)
