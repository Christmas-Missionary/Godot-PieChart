extends Control

var _pie_chart: PieChart

func _unhandled_key_input(_event) -> void:
	if Input.is_physical_key_pressed(KEY_SPACE):
		_pie_chart.queue_free()
		_set_up()

func _set_up() -> void:
	const _MAX_SIZE: int = 10
	var pack: PieChartEntryQuickPack = PieChartEntryQuickPack.new(
		{"1": 1.0, "2": 1.0, "3": 1.0, "4": 1.0, "5": 1.0, "6": 1.0, "7": 1.0, "8": 1.0, "9": 1.0, "10": 1.0},
		func(val: Color) -> Color: return val.lerp(Color(randf(), randf(), randf()), randf()),
		Color(randf(), randf(), randf())
	)
	var strings: Array[String] = []
	var err: int = strings.resize(_MAX_SIZE)
	assert(err == Error.OK, "Array couldn't resize!")
	strings.fill("%n\n%p%w")
	_pie_chart = PieChart.new_with_labels(pack.with_formatting(strings)).with_parent_as(self)
	for label: PieChartEntryLabel in _pie_chart.get_entry_labels().slice(randi_range(2, _MAX_SIZE)) as Array[PieChartEntryLabel]:
		label.disabled = true
