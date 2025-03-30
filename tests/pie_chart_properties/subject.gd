extends PieChart

func _ready() -> void:
	super() # <-- WARNING NOTICE CAUTION NOTE, THIS IS VITALLY IMPORTANT!!!
	push_error("Note: When overriding `_ready` for PieChart, PieChartEntryLabel, and PieChartTitleLabel, call `super()` first!!")
	push_error("Note: This applies to `_draw` in PieChart as well!!")

func _change_factor(value: float) -> void:
	chart_radius_multiplier = value

func _physics_process(_delta: float) -> void:
	starting_offset_radians += 0.02
