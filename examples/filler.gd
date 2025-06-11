extends LabellessPieChart

func _ready() -> void:
	all_entries = [LabellessPieChartEntry.new(0, Color(randf(), randf(), randf())), LabellessPieChartEntry.new(100, Color(randf(), randf(), randf()))]

func _physics_process(_delta: float) -> void:
	all_entries[0].weight += 1
	all_entries[1].weight -= 1
	if all_entries[1].weight <= 0:
		all_entries = [LabellessPieChartEntry.new(0, Color(randf(), randf(), randf())), LabellessPieChartEntry.new(100, all_entries[0].color)]
