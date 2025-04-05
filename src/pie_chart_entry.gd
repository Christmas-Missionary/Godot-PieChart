class_name PieChartEntry extends Resource

@export var name: String
@export_range(0, 2 ** 64) var weight: float
@export var color: Color

static func with_formatting(entries: Array[PieChartEntry], formatting: Array[String]) -> Dictionary[PieChartEntry, String]:
	if entries.size() != formatting.size():
		push_error("Sizes of entries and formatting do not match! Using smaller size.")
	var res: Dictionary[PieChartEntry, String]
	for i: int in mini(entries.size(), formatting.size()):
		res[entries[i]] = formatting[i]
	return res

func _init(name_: String = "", weight_: float = 1.0, color_: Color = Color.BLACK) -> void:
	assert(signf(weight_) != -1, "The `weight` from a PieChartEntry is NOT supposed to be negative!")
	name = name_
	weight = weight_
	color = color_
