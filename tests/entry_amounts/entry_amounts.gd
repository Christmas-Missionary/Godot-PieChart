extends Control

@onready var _subject: PieChart = $Subject as PieChart

var _entries: Array[PieChartEntry] = [
	PieChartEntry.new("Red", 1.0, Color.RED),
	PieChartEntry.new("Blue", 1.0, Color.BLUE),
	null
]

func _ready() -> void:
	_subject.set_up_labels(_entries, [])

func _on_timer_timeout() -> void:
	var third_entry: PieChartEntry = PieChartEntry.new("Green", 1.0, Color.GREEN)
	_entries[2] = third_entry if (_entries[2] == null) else null
	_subject.set_up_labels(_entries, [])
