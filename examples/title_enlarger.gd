extends PieChartTitleLabel

@onready var _chart_radius: float = (get_parent() as PieChart).get_chart_radius()
@onready var _other_label: PieChartEntryLabel = $"../1" as PieChartEntryLabel

func _ready() -> void:
	super()
	circle_color = Color(randf(), randf(), randf())
	_other_label.entry.color = Color(randf(), randf(), randf())

func _physics_process(_delta: float) -> void:
	circle_radius += 1
	if circle_radius >= _chart_radius:
		_other_label.entry.color = circle_color
		circle_color = Color(randf(), randf(), randf())
		circle_radius = 0
