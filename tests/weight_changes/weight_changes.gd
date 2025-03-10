extends Control

@onready var _subject: = $Subject as PieChart

var _entries: Array[PieChartEntry] = [
	PieChartEntry.new("Dogs", 25.0, Color.BROWN),
	PieChartEntry.new("Cats", 75.0, Color.CORNSILK)
]

var _is_zero_increasing: bool = true

func _ready() -> void:
	_subject.entries = _entries

const _RATE: float = 0.5

func _physics_process(_delta) -> void:
	if _is_zero_increasing:
		_entries[0].weight += _RATE
		_entries[1].weight -= _RATE
	else:
		_entries[0].weight -= _RATE
		_entries[1].weight += _RATE
		
	if is_equal_approx(_entries[0].weight, 1.0):
		_is_zero_increasing = true
	elif is_equal_approx(_entries[1].weight, 1.0):
		_is_zero_increasing = false
	_subject.entries = _entries
