extends PieChartEntryLabel

var _rects: Array[Node]

@onready var _main: Node = $"/root/PieChartProperties"
@onready var _chart: PieChart = get_parent() as PieChart

var rads_rotated: float = 0.0
var last_rot: float = 0.0

func _ready() -> void:
	super()
	set_physics_process(false)

func _on_trace_button_pressed() -> void:
	_rects = []
	rads_rotated = 0.0
	set_physics_process(true)
	last_rot = _chart.starting_offset_radians

func _physics_process(_delta: float) -> void:
	var to_drop: ColorRect = preload("res://tests/pie_chart_properties/rect.tscn").instantiate() as ColorRect
	_rects.push_back(to_drop)
	_main.add_child(to_drop)
	to_drop.global_position = get_global_rect().position + get_global_rect().size / 2
	if rads_rotated >= TAU:
		set_physics_process(false)
		(_main.get_node("TraceButton") as CanvasItem).show()
	else:
		rads_rotated += (_chart.starting_offset_radians - last_rot)
		last_rot = _chart.starting_offset_radians
