extends Control

const AMOUNT: int = 200

@onready var chart: PieChart = PieChart.new_with_labels(AMOUNT, false)

func _ready() -> void:
	var to_assign: Array[PieChartEntry]
	var err: int = to_assign.resize(AMOUNT)
	assert(err == 0, "Something horrible wrong has happened!")
	for i: int in AMOUNT:
		to_assign[i] = PieChartEntry.new(str(i), 1, Color(randf(), randf(), randf()))
	chart.with_parent_as(self).set_up_labels(to_assign, ["This should\nappear in\nfront of\nColorRect."])
	chart.chart_radius_multiplier = 2.0
	for label: PieChartEntryLabel in chart.get_entry_labels():
		label.separation_show = false

func _unhandled_key_input(_event) -> void:
	if Input.is_physical_key_pressed(KEY_SPACE):
		for label: PieChartEntryLabel in chart.get_entry_labels():
			label.entry.color = Color(randf(), randf(), randf())
