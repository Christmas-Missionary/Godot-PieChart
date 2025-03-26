class_name PieChartEntryLabel extends RichTextLabel

signal property_changed

@export var text_format: String:
	set(val):
		text_format = val
		property_changed.emit()

@export var entry: PieChartEntry:
	set(val):
		entry = val
		property_changed.emit()
	get():
		property_changed.emit()
		return entry

@export var is_in_slice: bool:
	set(val):
		is_in_slice = val
		property_changed.emit()

@export_group("Separation", "separation_")
@export var separation_show: bool = true:
	set(val):
		separation_show = val
		property_changed.emit()

@export var separation_color: Color = Color.WHITE:
	set(val):
		separation_color = val
		property_changed.emit()

@export_range(0, 1000) var separation_thickness: float = 3.0:
	set(val):
		assert(separation_thickness >= 0, "Someone changed the range of `separation_thickness` in PieChart!")
		separation_thickness = val
		property_changed.emit()

func _ready() -> void:
	var err: int = property_changed.connect((get_parent() as CanvasItem).queue_redraw)
	assert(err == 0, "Couldn't connect signals!")

func set_itself(percentage: float, center_pos: Vector2) -> void:
	text = text_format.replace("%n", entry.name).replace("%w", "%.2f\n" % entry.weight).replace("%p", "%.2f%%\n" % percentage).replace("%%", "%")
	size = Vector2(get_content_width() + 10, get_content_height() + 10)
	position = center_pos - (size / 2)
