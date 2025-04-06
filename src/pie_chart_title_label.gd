class_name PieChartTitleLabel extends RichTextLabel

var _drawer: Node2D = Node2D.new()

@export_group("Circle", "circle_")
@export var circle_color: Color = Color.BLACK:
	set(val):
		circle_color = val
		_drawer.queue_redraw()

@export_range(0, 1000) var circle_radius: float = 0.0:
	set(val):
		circle_radius = val
		_drawer.queue_redraw()

func set_label(text_: String, color: Color, radius: float) -> void:
	text = text_
	circle_color = color
	circle_radius = radius

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	assert(get_parent() as Control, "Parent is not a Control node!")
	size = (get_parent() as Control).size
	add_child(_drawer, false, Node.INTERNAL_MODE_FRONT)
	_drawer.show_behind_parent = true
	_drawer.set_script(preload("res://src/circle_drawer.gd"))
