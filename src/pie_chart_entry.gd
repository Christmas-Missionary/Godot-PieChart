extends Resource
class_name PieChartEntry

@export var name: String
@export_range(0, 2 ** 64) var weight: float
@export var color: Color

func _init(name_: String = "", weight_: float = 0.0, color_: Color = Color.BLACK) -> void:
	assert(weight >= 0.0, "Someone changed the range of `weight` in PieChartEntry!")
	name = name_
	weight = weight_
	color = color_
