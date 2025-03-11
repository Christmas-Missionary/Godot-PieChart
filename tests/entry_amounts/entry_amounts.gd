extends Control

@onready var _subject: = $Subject as PieChart

var _entries: Array[PieChartEntry] = [
	PieChartEntry.new("Red", 1, Color.RED),
	PieChartEntry.new("Blue", 1.0, Color.BLUE)
]

func _ready() -> void:
	_subject.entries = _entries

func _on_timer_timeout() -> void:
	if _entries.size() == 3:
		_entries.pop_back()
	elif _entries.size() == 2:
		_entries.push_back(PieChartEntry.new("Green", 1.0, Color.GREEN))
	_subject.entries = _entries
