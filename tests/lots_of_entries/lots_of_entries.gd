extends Control

func _ready() -> void:
	var sub: = $Subject as PieChart
	var to_assign: Array[PieChartEntry]
	for i: int in 100:
		to_assign.push_back(PieChartEntry.new(str(i), 1, Color(randf(), randf(), randf())))
	sub.entries = to_assign

func _unhandled_key_input(_event) -> void:
	if Input.is_physical_key_pressed(KEY_SPACE):
		var sub: = $Subject as PieChart
		for i: int in 100:
			sub.entries[i].color = Color(randf(), randf(), randf())
