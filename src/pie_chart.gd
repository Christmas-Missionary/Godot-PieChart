class_name PieChart extends Control

@export_group("Slices")
@export_range(0, 10) var chart_radius_multiplier: float = 1.0: 
	set(val):
		assert(chart_radius_multiplier >= 0 && chart_radius_multiplier <= 10, "Someone changed the range of `chart_radius_multiplier` in PieChart!")
		chart_radius_multiplier = val
		queue_redraw()

@export_range(0, TAU) var starting_offset_radians: float:
	set(val):
		assert(starting_offset_radians >= 0 && starting_offset_radians <= (TAU + 0.1), "Someone changed the range of `starting_offset_radians` in PieChart!")
		starting_offset_radians = val
		queue_redraw()

static func new_with_labels(num_of_labels: int, with_title: bool) -> PieChart:
	var res: PieChart = PieChart.new()
	if with_title:
		res.add_child(PieChartTitleLabel.new())
	for i: int in num_of_labels:
		res.add_child(PieChartEntryLabel.new())
	return res

func with_parent_as(node: Node) -> PieChart:
	node.add_child(self)
	return self

## Not used by src directly
func set_up_labels(entries: Array[PieChartEntry], text: Array[String] = []) -> void:
	var children: Array[PieChartEntryLabel] = get_entry_labels()
	for i: int in mini(children.size(), text.size()):
		children[i].text_format = text[i]
	for i: int in mini(children.size(), entries.size()):
		children[i].entry = entries[i]
	queue_redraw()

func _init() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

# find number of points/sides needed for perfect circle
func _draw_circle_arc_poly(center: Vector2, radius: float, rads_from: float, rads_to: float, color: Color, number_of_points: int) -> void:
	var previous_vec: Vector2 = Vector2.from_angle(rads_from) * radius
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	var points_arc: PackedVector2Array
	var err: int = points_arc.resize(number_of_points + 2)
	assert(err == Error.OK, "Something horribly wrong has happened!")
	points_arc[0] = center
	points_arc[1] = previous_vec + center
	for i: int in range(2, number_of_points + 2):
		previous_vec = previous_vec.rotated(rads_to_rotate)
		points_arc[i] = previous_vec + center
	draw_colored_polygon(points_arc, color)

func _weight_sum(arr: Array[PieChartEntryLabel]) -> float:
	var res: float = 0
	for node: PieChartEntryLabel in arr:
		res += (0.0 if node.entry == null else node.entry.weight)
	if is_zero_approx(res):
		push_error("All the entries total zero!")
	return res

func get_entry_labels() -> Array[PieChartEntryLabel]:
	var children: Array[Node] = get_children()
	var res: Array[PieChartEntryLabel]
	for node: Node in children:
		if node is PieChartEntryLabel && !node.is_queued_for_deletion():
			res.push_back(node as PieChartEntryLabel)
	return res

func _draw() -> void:
	var label_nodes: Array[PieChartEntryLabel] = get_entry_labels()
	if label_nodes.size() == 0:
		push_error("There are no entry label children!")
		return
	var hundredth_of_total: float = _weight_sum(label_nodes) * 0.01
	var center: Vector2 = size / 2
	var radius: float = (minf(size.x, size.y) / 4) * chart_radius_multiplier
	var begin_rads: float = starting_offset_radians
	for label: PieChartEntryLabel in label_nodes:
		if label.entry == null:
			continue
		var percentage: float = label.entry.weight / hundredth_of_total
		var rads_from_begin_angle: float = percentage * 0.0628318530717959 # (TAU * 0.01)
		_draw_circle_arc_poly(center, radius, begin_rads, begin_rads + rads_from_begin_angle, label.entry.color, ceili(64.0 * 0.01 * percentage))
		var label_angle_point: Vector2 = Vector2.from_angle(rads_from_begin_angle + begin_rads - (rads_from_begin_angle / 2)) * radius
		label.set_itself(percentage, label_angle_point * (0.5 if label.is_in_slice else 1.6) + center)
		if label.text != "" and !label.is_in_slice:
			draw_line((label_angle_point * 1.05) + center, (label_angle_point * 1.2) + center, Color.WHITE, 2, true)
		if label.separation_show:
			draw_line(center, Vector2.from_angle(begin_rads) * radius + center, label.separation_color, label.separation_thickness, true)
		begin_rads += rads_from_begin_angle
