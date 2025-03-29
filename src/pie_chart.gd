class_name PieChart extends Control

@export_group("Slices")
@export_range(0, 10) var chart_radius_multiplier: float = 1.0: 
	set(val):
		chart_radius_multiplier = val
		queue_redraw()

@export_range(0, TAU) var starting_offset_radians: float:
	set(val):
		starting_offset_radians = val
		queue_redraw()

static func new_with_labels(entries_with_format: Dictionary[PieChartEntry, String], with_title: bool = false) -> PieChart:
	var res: PieChart = PieChart.new()
	if with_title:
		res.add_child(PieChartTitleLabel.new())
	var entries: Array[PieChartEntry] = entries_with_format.keys() as Array[PieChartEntry]
	var formatting: Array[String] = entries_with_format.values() as Array[String]
	for i: int in entries_with_format.size():
		res.add_child(PieChartEntryLabel.new().set_entry_and_format(entries[i], formatting[i]))
	return res

func with_parent_as(node: Node) -> PieChart:
	node.add_child(self)
	return self

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT, true)

func _draw_circle_arc_poly(center: Vector2, radius: float, rads_from: float, rads_to: float, color: Color, number_of_points: int) -> void:
	var previous_vec: Vector2 = Vector2.from_angle(rads_from) * radius
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	var points_arc: PackedVector2Array
	var err: int = points_arc.resize(number_of_points + 2)
	assert(err == Error.OK, "Array couldn't be resized!")
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
	var label_nodes: Array[PieChartEntryLabel] = get_entry_labels().filter(func(label: PieChartEntryLabel) -> bool: return !label.disabled) as Array[PieChartEntryLabel]
	if label_nodes.size() == 0:
		push_error("PieChart must have at least one child of type PieChartEntryLabel to work!")
		return
	var hundredth_of_total: float = _weight_sum(label_nodes) * 0.01
	var center: Vector2 = size / 2
	var radius: float = (minf(size.x, size.y) / 4) * chart_radius_multiplier
	var begin_rads: float = starting_offset_radians
	for label: PieChartEntryLabel in label_nodes:
		if label.disabled or label.entry == null:
			continue
		var percentage: float = label.entry.weight / hundredth_of_total
		var rads_from_begin_angle: float = percentage * 0.0628318530717959 # TAU / 100.0 = 0.0628318530717959
		_draw_circle_arc_poly(center, radius, begin_rads, begin_rads + rads_from_begin_angle, label.entry.color, ceili(0.64 * percentage)) # 64 / 100.0 = 0.64
		var label_angle_point: Vector2 = Vector2.from_angle(rads_from_begin_angle + begin_rads - (rads_from_begin_angle / 2)) * radius
		label.set_itself(percentage, label_angle_point * (0.5 if label.is_in_slice else 1.6) + center)
		if label.text != "" and !label.is_in_slice:
			draw_line((label_angle_point * 1.05) + center, (label_angle_point * 1.2) + center, Color.WHITE, 2, true)
		if label.separation_show:
			draw_line(center, Vector2.from_angle(begin_rads) * radius + center, label.separation_color, label.separation_thickness, true)
		begin_rads += rads_from_begin_angle
	draw_line(center, Vector2.from_angle(starting_offset_radians) * radius + center, label_nodes[0].separation_color, label_nodes[0].separation_thickness, true)
