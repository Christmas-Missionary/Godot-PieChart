class_name PieChartEntryLabel extends RichTextLabel

signal property_changed

@export var entry: PieChartEntry:
	set(val):
		entry = val
		property_changed.emit()
	get():
		property_changed.emit()
		return entry

@export var text_format: String:
	set(val):
		text_format = val
		property_changed.emit()

@export var disabled: bool:
	set(val):
		disabled = val
		visible = !val
		property_changed.emit()

@export var is_in_slice: bool:
	set(val):
		is_in_slice = val
		property_changed.emit()

@export_group("Separation", "separation_")
@export var separation_show: bool:
	set(val):
		separation_show = val
		property_changed.emit()

@export var separation_color: Color = Color.WHITE:
	set(val):
		separation_color = val
		property_changed.emit()

@export_range(0, 1000) var separation_thickness: float = 3.0:
	set(val):
		separation_thickness = val
		property_changed.emit()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	assert((get_parent() as PieChart), "Parent is not a PieChart!")
	var err: int = property_changed.connect((get_parent() as PieChart).queue_redraw)
	assert(err == Error.OK, "Couldn't connect signal!")

func set_entry_and_format(_entry: PieChartEntry, format: String) -> PieChartEntryLabel:
	entry = _entry
	text_format = format
	return self

func set_itself(percentage: float, center_pos: Vector2) -> void:
	text = text_format.replace("%n", entry.name).replace("%w", "%.2f\n" % entry.weight).replace("%p", "%.2f%%\n" % percentage).replace("%%", "%")
	size = Vector2(get_content_width() + 30, get_content_height() + 30)
	position = center_pos - (size / 2)
