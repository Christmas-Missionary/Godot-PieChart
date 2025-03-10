extends Control

@onready var _subject: = $Subject as PieChart
@onready var _labels: Node = $Subject/Labels

var _entries: Array[PieChartEntry] = [
	PieChartEntry.new("Dogs", 0.0, Color.BROWN),
	PieChartEntry.new("Cats", 100.0, Color.CORNSILK)
]

func _ready() -> void:
	_subject.entries = _entries

const _RATE: float = 0.1

func _physics_process(_delta) -> void:
	_entries[0].weight += _RATE
	_entries[1].weight -= _RATE
	_subject.entries = _entries
	for label: Node in _labels.get_children():
		var _rect: = ColorRect.new()
		add_child(_rect)
		_rect.global_position = (label as Control).position + (_subject.size / 2)
		_rect.size = Vector2.ONE
	if is_zero_approx(_entries[1].weight):
		_subject.entries = []
		set_physics_process(false)
