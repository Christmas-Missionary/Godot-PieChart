extends Control

@onready var _subject: PieChart = $Subject as PieChart

var _entries: Array[PieChartEntry] = [
	PieChartEntry.new("Dogs", 0.0, Color.BROWN),
	PieChartEntry.new("Cats", 100.0, Color.CORNSILK)
]

func _ready() -> void:
	var arr: Array[String]
	var err: int = arr.resize(3)
	assert(err == 0, "Something horribly wrong has happened!")
	arr.fill("%n\n%w%p")
	_subject.set_up_labels(_entries, arr)

const _RATE: float = 0.1

func _physics_process(_delta) -> void:
	_entries[0].weight += _RATE
	_entries[1].weight -= _RATE
	_subject.set_up_labels(_entries)
	for label: PieChartEntryLabel in _subject.get_entry_labels():
		var _rect: ColorRect = ColorRect.new()
		add_child(_rect)
		_rect.global_position = (label as Control).position + (Vector2(label.get_content_width(), label.get_content_height()) / 2)
		_rect.size = Vector2.ONE
	if is_zero_approx(_entries[1].weight):
		_subject.set_up_labels([], ["", "", ""])
		set_physics_process(false)
