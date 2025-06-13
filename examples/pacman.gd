extends LabellessPieChart

var _curr_mouth_value: int = 10
var _is_mouth_opening: bool = false

func _physics_process(_delta: float) -> void:
	_curr_mouth_value += (1 if _is_mouth_opening else -1)
	starting_offset_radians += (0.075 if _is_mouth_opening else -0.075)
	all_entries[1].weight = _curr_mouth_value / 10.0
	if _curr_mouth_value <= 0:
		_is_mouth_opening = true
	elif _curr_mouth_value >= 10:
		_is_mouth_opening = false
