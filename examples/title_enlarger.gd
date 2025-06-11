extends PieChartTitleLabel

@onready var _parent: LabellessPieChart = get_parent() as LabellessPieChart
@onready var _chart_radius: float = _parent.get_chart_radius()

func _ready() -> void:
	super()
	circle_color = Color(randf(), randf(), randf())
	_parent.all_entries = [LabellessPieChartEntry.new(1.0, Color(randf(), randf(), randf()))]

func _physics_process(_delta: float) -> void:
	circle_radius += 1
	if circle_radius >= _chart_radius:
		_parent.all_entries[0].color = circle_color
		circle_color = Color(randf(), randf(), randf())
		circle_radius = 0
