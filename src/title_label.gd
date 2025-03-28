class_name PieChartTitleLabel extends RichTextLabel

var _drawer: Node2D = Node2D.new()

@export_group("Circle", "circle_")
@export var circle_color: Color:
	set(val):
		circle_color = val
		_drawer.queue_redraw()

@export_range(0, 1000) var circle_radius: float:
	set(val):
		circle_radius = val
		_drawer.queue_redraw()

func _ready() -> void:
	assert(get_parent() as Control != null, "Parent is not a Control node!")
	size = (get_parent() as Control).size
	add_child(_drawer, false, Node.INTERNAL_MODE_FRONT)
	_drawer.show_behind_parent = true
	_drawer.set_script(preload("res://src/circle_drawer.gd"))
