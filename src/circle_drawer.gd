extends Node2D

func _draw() -> void:
	var parent: PieChartTitleLabel = get_parent() as PieChartTitleLabel
	assert(parent != null, "Parent is not a PieChartTitleLabel!")
	draw_circle(parent.size / 2, parent.circle_radius, parent.circle_color)
