extends Resource
class_name EntryQuickPack

enum COLOR_SCALE {GREY_SCALE}
@export var color_scale: COLOR_SCALE
@export var values: Dictionary[String, float]

func _init(scale: COLOR_SCALE = COLOR_SCALE.GREY_SCALE, vals: Dictionary[String, float] = {}) -> void:
	color_scale = scale
	values = vals
