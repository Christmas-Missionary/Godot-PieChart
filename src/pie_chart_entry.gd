class_name PieChartEntry extends Resource

@export var name: String
@export_range(0, 2 ** 64) var weight: float
@export var color: Color

func _init(name_: String = "", weight_: float = 0.0, color_: Color = Color.BLACK) -> void:
	assert(signf(weight_) != -1, "The `weight` from a PieChartEntry is NOT supposed to be negative!")
	name = name_
	weight = weight_
	color = color_
