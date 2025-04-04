extends PieChart

var increase_chart_one: bool = true

@onready var one: PieChartEntryLabel = $"1" as PieChartEntryLabel
@onready var two: PieChartEntryLabel = $"2" as PieChartEntryLabel

func _ready() -> void:
	super()
	one.entry = PieChartEntry.new("", 1, Color(randf(), randf(), randf()))
	two.entry = PieChartEntry.new("", 99, Color(randf(), randf(), randf()))

func _physics_process(_delta: float) -> void:
	if increase_chart_one:
		one.entry.weight += 1
		two.entry.weight -= 1
		if two.entry.weight <= 0:
			increase_chart_one = false
			move_child(two, 0)
			two.entry.color = Color(randf(), randf(), randf())
	else:
		one.entry.weight -= 1
		two.entry.weight += 1
		if one.entry.weight <= 0:
			increase_chart_one = true
			move_child(one, 0)
			one.entry.color = Color(randf(), randf(), randf())
