class_name PieChartEntryQuickPack extends Resource

enum COLOR_SCALE {GREY_SCALE}
@export var color_scale: COLOR_SCALE
@export var values: Dictionary[String, float]

func _init(vals: Dictionary[String, float] = {}, scale: COLOR_SCALE = COLOR_SCALE.GREY_SCALE) -> void:
	color_scale = scale
	values = vals
