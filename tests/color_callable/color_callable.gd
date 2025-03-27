extends Control

func _unhandled_key_input(_event) -> void:
	if Input.is_physical_key_pressed(KEY_SPACE):
		_set_up()

func _set_up() -> void:
	var pack: PieChartEntryQuickPack = PieChartEntryQuickPack.new(
		{"1": 1.0, "2": 1.0, "3": 1.0, "4": 1.0, "5": 1.0},
		func(val: Color) -> Color: return val.lerp(Color(randf(), randf(), randf()), randf()),
		Color(randf(), randf(), randf())
	)
	($Subject as PieChart).set_up_labels(pack.to_array())
