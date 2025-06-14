class_name LabellessPieChart extends Control
## A control that provides pie chart and doughnut chart functionality [b]without[/b] any labels, usually for designs as opposed to proper pie charts.
##
## This is a singular node that takes in an [code]Array[LabellessPieChartEntry][/code] as [member all_entries] and draws its proportions.
## [b]It is fully dependent on the size you give it to draw the labelless pie chart.[/b][br][br]
## [b]Note:[/b] It must need at least one valid [LabellessPieChartEntry] in [member all_entries] in order to render.[br][br]
## This class uses [method CanvasItem._draw] to draw the slices on the pie chart.
## This means that any manipulation of [member all_entries] [member chart_radius_multiplier] and [member starting_offset_radians] results in [method queue_redraw] being called.[br][br]
## However, if the node doesn't seem to be changing, but the values inside [member all_entries] are in fact changing (via a [Tween], for example), use this:
## [codeblock]
## extends Control
##
## func _physics_process(_delta: float) -> void:
##     queue_redraw()
## [/codeblock]
##
## Though you can build a [LabellessPieChart] in the editor, you can instantiate one with just a few lines of code.
## The codeblock below shows an example of this:[br]
##
## [codeblock]
## extends Control
##
## @onready var _chart: LabellessPieChart = (
##    LabellessPieChart.new()
##            .with_parent_as(self)
##            .with_entries([LabellessPieChartEntry.new(3.0, Color.RED), LabellessPieChartEntry.new(2.0, Color.GREEN)])
##            .set_position_and_size(Vector2(100.0, 50.0), Vector2(600.0, 600.0))
##)
## [/codeblock]

## An array of all the entries for a [LabellessPieChart]. 
@export var all_entries: Array[LabellessPieChartEntry]:
	set(val):
		all_entries = val
		queue_redraw()
	get():
		queue_redraw()
		return all_entries

@export_group("Slices")
## Multiplies the current radius of the chart by some factor. To size the pie chart exactly, use [member Control.size] or [method Control.set_anchors_preset].
@export_range(0, 10) var chart_radius_multiplier: float = 1.0: 
	set(val):
		chart_radius_multiplier = val
		queue_redraw()

## Offsets the pie chart by a certain amount of radians. Use this if you don't want the first entry to be on the bottom-right corner.
@export_range(0, TAU) var starting_offset_radians: float = 0.0:
	set(val):
		starting_offset_radians = val
		queue_redraw()

## Returns the current radius of the pie chart, which is [code](minf(size.x, size.y) / 4.0) * chart_radius_multiplier[/code].
func get_chart_radius() -> float:
	return (minf(size.x, size.y) / 4) * chart_radius_multiplier

## Used to pipeline instantiating a LabellessPieChart and adding it as a child.
func with_parent_as(node: Node) -> LabellessPieChart:
	assert(node != null, "Node to be parent is null!")
	node.add_child(self)
	return self

## A setter for [member all_entries] and returns the node calling the method. Nice for Pipelining.
func with_entries(entries: Array[LabellessPieChartEntry]) -> LabellessPieChart:
	all_entries = entries
	return self

## Sets the position and size, then returns itself.
func set_position_and_size(pos: Vector2, size_: Vector2) -> LabellessPieChart:
	if is_nan(pos.x) or is_nan(pos.y):
		push_error("Position to set on node %s contains a NAN value!" % str(self))
	if is_inf(pos.x) or is_inf(pos.y):
		push_error("Position to set on node %s contains an INF value!" % str(self))
	if is_nan(size_.x) or is_nan(size_.y):
		push_error("Size to set on node %s contains a NAN value!" % str(self))
	if is_inf(size_.x) or is_inf(size_.y):
		push_error("Size to set on node %s contains an INF value!" % str(self))
	position = pos
	size = size_
	return self

func _weight_sum() -> float:
	if all_entries == null:
		push_error("There are no entries!")
		return 0.0
	var res: float = 0.0
	for entry: LabellessPieChartEntry in all_entries:
		if entry == null:
			continue
		assert(!is_nan(entry.weight), "Value of weight in `all_entries` is NAN!")
		assert(!is_inf(entry.weight), "Value of weight in `all_entries` is infinite!")
		res += entry.weight
	return res

func _draw() -> void:
	var hundredth_of_total: float = _weight_sum() * 0.01
	var center: Vector2 = size / 2
	var radius: float = get_chart_radius()
	var begin_rads: float = starting_offset_radians
	for entry: LabellessPieChartEntry in all_entries:
		if entry == null || entry.weight <= 0:
			continue
		var percentage: float = entry.weight / hundredth_of_total
		var rads_from_begin_angle: float = percentage * (TAU / 100)
		draw_colored_polygon(PieChart.circle_arc_poly(center, radius, begin_rads, begin_rads + rads_from_begin_angle, ceili(0.64 * percentage)), entry.color) # 64 / 100.0 = 0.64
		if entry.separation_thickness > 0.0:
			draw_line(center, Vector2.from_angle(begin_rads) * radius + center, entry.separation_color, entry.separation_thickness, true)
		begin_rads += rads_from_begin_angle
	if all_entries != null and all_entries.size() and all_entries[0] != null and all_entries[0].separation_thickness > 0.0:
		draw_line(center, Vector2.from_angle(starting_offset_radians) * radius + center, all_entries[0].separation_color, all_entries[0].separation_thickness, true)
