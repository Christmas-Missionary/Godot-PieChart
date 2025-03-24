extends RichTextLabel
class_name EntryLabel

@export var entry: PieChartEntry:
	set(val):
		entry = val
		queue_redraw()

@export var is_in_slice: bool:
	set(val):
		is_in_slice = val
		queue_redraw()

@export_group("Text Contents")
@export var show_name: bool = true:
	set(val):
		show_name = val
		queue_redraw()

@export var show_weights: bool = true:
	set(val):
		show_weights = val
		queue_redraw()

@export var show_percentage: bool = true:
	set(val):
		show_percentage = val
		queue_redraw()

@export_group("Separation", "separation_")
@export var separation_show: bool = true:
	set(val):
		separation_show = val
		queue_redraw()

@export var separation_color: Color = Color.WHITE:
	set(val):
		separation_color = val
		queue_redraw()

@export_range(0, 1000) var separation_thickness: float = 3.0:
	set(val):
		assert(separation_thickness >= 0, "Someone changed the range of `separation_thickness` in PieChart!")
		separation_thickness = val
		queue_redraw()

func set_itself(percentage: float, center_pos: Vector2) -> void:
	text = (
		("Name: %s\n" % entry.name if show_name else "") +
		("Weight: %.2f\n" % entry.weight if show_weights else "") +
		("Percentage: %.2f%%\n" % percentage if show_percentage else "")
	)
	size = Vector2(get_content_width(), get_content_height())
	position = center_pos - (size / 2)
