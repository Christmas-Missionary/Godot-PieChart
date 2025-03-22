extends RichTextLabel
class_name PieChartTitleLabel

@export var circle_color: Color:
	set(val):
		circle_color = val
		_drawer.queue_redraw()

@export_range(0, 1000) var circle_radius: float:
	set(val):
		assert(circle_radius >= 0, "Someone changed the range of `title_circle_radius` in PieChart!")
		circle_radius = val
		_drawer.queue_redraw()

@onready var _drawer: Node2D = preload("res://src/circle_drawer.tscn").instantiate() as Node2D

func _ready() -> void:
	add_child(_drawer, false, Node.INTERNAL_MODE_FRONT)
