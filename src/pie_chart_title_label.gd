class_name PieChartTitleLabel extends RichTextLabel
## A control for the title of a pie chart.
##
## The only interaction with its parent is to grab the value from [member Control.size].
## This means that the parent must be a [Control] node, and not necessarily a [PieChart] node.[br][br]
## [color=red][b]Note:[/b] If you need to override [method Node._ready], make sure to call [code]super()[/code] first![/color]
## [codeblock]
## func _ready() -> void:
##    super()
##    # All other stuff
## [/codeblock]

@export_group("Circle", "circle_")
## The color of the circle drawn for the title.
@export var circle_color: Color = Color.BLACK:
	set(val):
		circle_color = val
		_drawer.queue_redraw()

## The length from the center of the circle to any edge.
@export_range(0, 1000) var circle_radius: float = 0.0:
	set(val):
		circle_radius = val
		_drawer.queue_redraw()

## A way to change the title label very quickly. For example:  
## [codeblock]
## extends PieChart
##
##func _ready() -> void:
##    get_title_label().set_label("Hello", Color.BLUE, 100.0)
## [/codeblock]
func set_label(text_: String, color: Color, radius: float) -> void:
	text = text_
	circle_color = color
	circle_radius = radius

var _drawer: Node2D = Node2D.new()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	assert(get_parent() as Control, "Parent is not a Control node!")
	size = (get_parent() as Control).size
	add_child(_drawer, false, Node.INTERNAL_MODE_FRONT)
	_drawer.show_behind_parent = true
	_drawer.set_script(preload("res://src/circle_drawer.gd"))
