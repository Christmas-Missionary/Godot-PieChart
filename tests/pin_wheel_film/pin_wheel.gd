extends PieChart

func _ready() -> void:
	var entries: Array[PieChartEntry] = [
		PieChartEntry.new("", 1, Color.RED),
		PieChartEntry.new("", 1, Color.ORANGE),
		PieChartEntry.new("", 1, Color.YELLOW),
		PieChartEntry.new("", 1, Color.GREEN),
		PieChartEntry.new("", 1, Color.BLUE),
		PieChartEntry.new("", 1, Color.VIOLET),
		PieChartEntry.new("", 1, Color.BROWN),
		PieChartEntry.new("", 1, Color.GRAY)
	]
	for entry: PieChartEntry in entries:
		add_child(PieChartEntryLabel.new().set_entry_and_format(entry, ""))

func _physics_process(_delta: float) -> void:
	starting_offset_radians += 0.025
	if starting_offset_radians >= TAU:
		get_tree().quit()
