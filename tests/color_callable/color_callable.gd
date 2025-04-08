extends Control

"""
Tests:
	Loads of entries
	PieChartEntryQuickPack
	init PieChart and PieChartEntryLabels
"""

var _pie_chart: PieChart

func _on_button_pressed() -> void:
	_pie_chart.queue_free()
	_set_up()

func _set_up() -> void:
	const _MIN_SIZE: int = 2
	const _MAX_SIZE: int = 100
	var dict_for_pack: Dictionary[String, float]
	for i: int in range(1, _MAX_SIZE + 1):
		dict_for_pack[String.num_int64(i)] = 1.0
	
	var pack: PieChartEntryQuickPack = PieChartEntryQuickPack.new(
		dict_for_pack,
		func(val: Color) -> Color: return val.lerp(Color(randf(), randf(), randf()), randf()),
		Color(randf(), randf(), randf())
	)
	var strings: Array[String] = []
	var err: int = strings.resize(_MAX_SIZE)
	assert(err == Error.OK, "Array couldn't resize!")
	strings.fill("%n\n%p%w")
	_pie_chart = PieChart.new().with_labels(pack.with_formatting(strings)).with_parent_as(self)
	_pie_chart.position = Vector2(400, 0)
	_pie_chart.size = Vector2(752, 648)
	for label: PieChartEntryLabel in _pie_chart.get_entry_labels().slice(randi_range(_MIN_SIZE, _MAX_SIZE)) as Array[PieChartEntryLabel]:
		label.disabled = true
