extends LabellessPieChart

"""
Tests:
	LabellessPieChart
	All of its properties
"""

var _rotation_speed: float = 0.0

func _on_timer_timeout() -> void:
	chart_radius_multiplier = randf_range(0.1, 3.5)
	starting_offset_radians = randf_range(0.0, TAU)
	_rotation_speed = randf_range(-0.01, 0.01)
	var to_insert: Array[LabellessPieChartEntry]
	for i: int in 100:
		to_insert.append(LabellessPieChartEntry.new(randf_range(1.0, 10.0), Color(randf(), randf(), randf()), randf_range(1.0, 10.0), Color(randf(), randf(), randf())))
	all_entries = to_insert

func _physics_process(_delta: float) -> void:
	starting_offset_radians += _rotation_speed
