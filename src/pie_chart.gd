class_name PieChart extends Control
## A control that provides pie chart and doughnut chart functionality for graphing proportions.
##
## This is the node that draws the entries from [PieChartEntryLabel] onto a circle.[br][br]
## [b]It is fully dependent on the size you give it to draw the pie chart.[/b][br][br]
## It can also act as a way to its children [PieChartEntryLabel] nodes and child [PieChartTitleLabel] with the lowest index amongst its siblings.
## See [method get_entry_labels], [method set_entry_labels], and [method get_title_label].[br][br]
## [b]Note:[/b] It must need at least one [PieChartEntryLabel] child in order to render.[br][br]
## This class uses [method CanvasItem._draw] to draw the slices on the pie chart.
## This means that any manipulation of the exclusive properties to the [PieChartEntryLabel] child nodes, [member chart_radius_multiplier], and [member starting_offset_radians] results in [method queue_redraw] being called.[br][br]
##
## However, if the node doesn't seem to be changing, but the values inside [member all_entries] are in fact changing (via a [Tween], for example), use this:
## [codeblock]
## extends Control
##
## func _physics_process(_delta: float) -> void:
##     queue_redraw()
## [/codeblock]
##
## Though you can build a [PieChart] in the editor, you can instantiate one with just a few lines of code.
## The codeblock below shows an example of this:[br]
##
## [codeblock]
## extends Control
##
## var entries_with_formatting: Dictionary[PieChartEntry, String] = {
##    PieChartEntry.new("Red", 1.0, Color.RED): "%n\n%p%w",
##    PieChartEntry.new("Green", 1.0, Color.GREEN): "%n\n%p%w"
## }
##
## @onready var _chart: PieChart = (
##    PieChart.new()
##            .with_parent_as(self)
##            .with_labels(entries_with_formatting, true)
##            .set_position_and_size(Vector2(100.0, 50.0), Vector2(600.0, 600.0))
##)
## [/codeblock]

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

## Returns an array of points representing a slice of a circle. For example:
## [codeblock]
## extends Node2D # or any CanvasItem
##
## func _draw() -> void:
##    draw_colored_polygon(PieChart.circle_arc_poly(Vector2(200.0, 100.0), 200.0, 0.0, TAU / 4.0, 16), Color.WHITE)
## [/codeblock]
## [b]Tip:[/b] To be basically indistinguishable with [method CanvasItem.draw_circle], you will need at least 64 points along the arc.
static func circle_arc_poly(center: Vector2, radius: float, rads_from: float, rads_to: float, number_of_points: int) -> PackedVector2Array:
	assert(number_of_points > 0, "Number of points to generate points for slice is at most zero!")
	var previous_vec: Vector2 = Vector2.from_angle(rads_from) * radius
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	var res: PackedVector2Array
	var err: int = res.resize(number_of_points + 2)
	assert(err == Error.OK, "Array couldn't be resized!")
	res[0] = center
	res[1] = previous_vec + center
	for i: int in range(2, number_of_points + 2):
		previous_vec = previous_vec.rotated(rads_to_rotate)
		res[i] = previous_vec + center
	return res

## Instantiates and sets up [PieChartEntryLabel] nodes, as well as instantiates a [PieChartTitleLabel] if needed.
func with_labels(entries_with_format: Dictionary[PieChartEntry, String], with_title: bool = false) -> PieChart:
	for node: Node in get_children():
		if node is PieChartTitleLabel or node is PieChartEntryLabel:
			node.queue_free()
	if with_title:
		add_child(PieChartTitleLabel.new())
	var entries: Array[PieChartEntry] = entries_with_format.keys() as Array[PieChartEntry]
	var formatting: Array[String] = entries_with_format.values() as Array[String]
	for i: int in entries_with_format.size():
		add_child(PieChartEntryLabel.new().set_entry_and_format(entries[i], formatting[i]))
	return self

## Sets each pre-existing [PieChartEntryLabel] node with an entry and text formatting.
func set_entry_labels(entries_with_format: Dictionary[PieChartEntry, String]) -> void:
	var entries: Array[PieChartEntry] = entries_with_format.keys() as Array[PieChartEntry]
	var formatting: Array[String] = entries_with_format.values() as Array[String]
	var labels: Array[PieChartEntryLabel] = get_entry_labels()
	for i: int in entries_with_format.size():
		var _discard: PieChartEntryLabel = labels[i].set_entry_and_format(entries[i], formatting[i])

## Returns the current radius of the pie chart, which is [code](minf(size.x, size.y) / 4.0) * chart_radius_multiplier[/code].
func get_chart_radius() -> float:
	return (minf(size.x, size.y) / 4) * chart_radius_multiplier

## Used to pipeline instantiating a PieChart and adding it as a child.
func with_parent_as(node: Node) -> PieChart:
	assert(node != null, "Node to be parent is null!")
	node.add_child(self)
	return self

## Returns an array of all [PieChartEntryLabel] children.
func get_entry_labels() -> Array[PieChartEntryLabel]:
	var res: Array[PieChartEntryLabel]
	for node: Node in get_children():
		if node is PieChartEntryLabel and !node.is_queued_for_deletion():
			res.push_back(node as PieChartEntryLabel)
	return res

## Returns the [PieChartTitleLabel] with the lowest child index.
func get_title_label() -> PieChartTitleLabel:
	for node: Node in get_children():
		if node is PieChartTitleLabel and !node.is_queued_for_deletion():
			return node as PieChartTitleLabel
	return null

## Sets the position and size, then returns itself.
func set_position_and_size(pos: Vector2, size_: Vector2) -> PieChart:
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

func _weight_sum(arr: Array[PieChartEntryLabel]) -> float:
	var res: float = 0
	if arr == null:
		push_error("There are no entry labels!")
		return 0.0
	for node: PieChartEntryLabel in arr:
		assert(!is_nan(node.entry.weight), "Value of weight in node %s is NAN!" % str(node))
		assert(!is_inf(node.entry.weight), "Value of weight in node %s is infinite!" % str(node))
		res += (0.0 if !node.entry or node.entry.weight <= 0.0 else node.entry.weight)
	if is_zero_approx(res):
		push_error("All the entries total zero!")
	return res

func _draw() -> void:
	var label_nodes: Array[PieChartEntryLabel] = get_entry_labels().filter(func(label: PieChartEntryLabel) -> bool: return !label.disabled) as Array[PieChartEntryLabel]
	if label_nodes.size() == 0:
		push_error("PieChart must have at least one child of type PieChartEntryLabel to work!")
		return
	var hundredth_of_total: float = _weight_sum(label_nodes) * 0.01
	var center: Vector2 = size / 2
	var radius: float = get_chart_radius()
	var begin_rads: float = starting_offset_radians
	for label: PieChartEntryLabel in label_nodes:
		if label.disabled or !label.entry or label.entry.weight <= 0:
			continue
		var percentage: float = label.entry.weight / hundredth_of_total
		var rads_from_begin_angle: float = percentage * (TAU / 100)
		draw_colored_polygon(circle_arc_poly(center, radius, begin_rads, begin_rads + rads_from_begin_angle, ceili(0.64 * percentage)), label.entry.color) # 64 / 100.0 = 0.64
		var label_angle_point: Vector2 = Vector2.from_angle(rads_from_begin_angle + begin_rads - (rads_from_begin_angle / 2)) * radius
		@warning_ignore("return_value_discarded")
		label.set_to_display(percentage, label_angle_point * (0.5 if label.is_in_slice else 1.6) + center)
		if label.text != "" and !label.is_in_slice:
			draw_line((label_angle_point * 1.05) + center, (label_angle_point * 1.2) + center, Color.WHITE, 2, true)
		if label.separation_show:
			draw_line(center, Vector2.from_angle(begin_rads) * radius + center, label.separation_color, label.separation_thickness, true)
		begin_rads += rads_from_begin_angle
	if label_nodes[0].separation_show:
		draw_line(center, Vector2.from_angle(starting_offset_radians) * radius + center, label_nodes[0].separation_color, label_nodes[0].separation_thickness, true)
