extends LabellessPieChart

func _ready() -> void:
	all_entries = [
		LabellessPieChartEntry.new(1, Color.RED),
		LabellessPieChartEntry.new(1, Color.ORANGE),
		LabellessPieChartEntry.new(1, Color.YELLOW),
		LabellessPieChartEntry.new(1, Color.GREEN),
		LabellessPieChartEntry.new(1, Color.BLUE),
		LabellessPieChartEntry.new(1, Color.VIOLET),
		LabellessPieChartEntry.new(1, Color.BROWN),
		LabellessPieChartEntry.new(1, Color.GRAY),
	]

func _physics_process(_delta: float) -> void:
	starting_offset_radians += 0.025
