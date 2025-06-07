extends PieChart

"""
Tests:
	PieChart and its own properties
	Use of theme
"""

@export var _rot: float = 0.02

func _ready() -> void:
	push_error("Note: When overriding `_ready` for PieChart, PieChartEntryLabel, and PieChartTitleLabel, call `super()` first!!")
	push_error("Note: This applies to `_draw` in PieChart as well!!")
	push_error("You can safely ignore these 3 errors!")

func _change_factor(value: float) -> void:
	chart_radius_multiplier = value

func _physics_process(_delta: float) -> void:
	starting_offset_radians += 0.02
	rotation -= _rot
