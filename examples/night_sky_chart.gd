extends LabellessPieChart

func _ready() -> void:
	var __: int = all_entries.resize(16)
	for i: int in 16:
		all_entries[i] = LabellessPieChartEntry.new()
	_tween_again()

func _tween_again() -> void:
	for i: int in 16:
		var __: PropertyTweener = create_tween().tween_property(all_entries[i], ^"color", Color(randf(), randf(), randf()), 5.0)

func _physics_process(_delta: float) -> void:
	queue_redraw()
