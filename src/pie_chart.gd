class_name PieChart extends Control

@export_group("Slices")
@export_range(0, 10) var chart_radius_multiplier: float = 1.0: 
	set(val):
		assert(chart_radius_multiplier >= 0, "Someone changed the range of `chart_radius_multiplier` in PieChart!")
		chart_radius_multiplier = val
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

func _weight_sum(arr: Array[EntryLabel]) -> float:
	var res: float = 0
	for node: EntryLabel in arr:
		res += node.entry.weight
	if is_zero_approx(res):
		push_error("All the entries total zero!")
	return res

#func _entry_quick_pack_to_arr(quick_pack: PieChartEntryQuickPack) -> Array[PieChartEntry]:
	#var names: Array[String] = quick_pack.values.keys() as Array[String]
	#var weights: Array[float] = quick_pack.values.values() as Array[float]
	#
	#var r_inc: int
	#var g_inc: int
	#var b_inc: int
	#
	#match quick_pack.color_scale:
		#PieChartEntryQuickPack.COLOR_SCALE.GREY_SCALE:
			#r_inc = 50
			#g_inc = 50
			#b_inc = 50
	#
	#var res: Array[PieChartEntry]
	#var err: int = res.resize(quick_pack.values.size())
	#assert(err == Error.OK, "Something horribly wrong has happened!")
	#var color_generated: Color
	#for i: int in quick_pack.values.size():
		#res[i] = PieChartEntry.new(names[i], weights[i], color_generated)
		#color_generated.r8 += r_inc
		#color_generated.g8 += g_inc
		#color_generated.b8 += b_inc
	#return res

func children_to_entry_label() -> Array[EntryLabel]:
	var children: Array[Node] = get_children()
	var res: Array[EntryLabel]
	for node: Node in children:
		if node is EntryLabel && !node.is_queued_for_deletion():
			res.push_back(node as EntryLabel)
	return res

func _draw() -> void:
	var label_nodes: Array[EntryLabel] = children_to_entry_label()
	var hundredth_of_total: float = _weight_sum(label_nodes) * 0.01
	var center: Vector2 = size / 2
	var radius: float = (minf(size.x, size.y) / 4) * chart_radius_multiplier
	var begin_rads: float = 0
	var number_of_points: int = ceili(64.0 / label_nodes.size())
	for label: EntryLabel in label_nodes:
		var percentage: float = label.entry.weight / hundredth_of_total
		var rads_from_begin_angle: float = percentage * 0.0628318530717959 # (TAU * 0.01)
		_draw_circle_arc_poly(center, radius, begin_rads, begin_rads + rads_from_begin_angle, label.entry.color, number_of_points)
		var label_angle_point: Vector2 = Vector2.from_angle(rads_from_begin_angle + begin_rads - (rads_from_begin_angle / 2)) * radius
		label.set_itself(percentage, label_angle_point * (0.5 if label.is_in_slice else 1.7) + center)
		if label.text != "" and !label.is_in_slice:
			draw_line((label_angle_point * 1.05) + center, (label_angle_point * 1.2) + center, Color.WHITE, 2, true)
		if label.separation_show:
			draw_line(center, Vector2.from_angle(begin_rads) * radius + center, label.separation_color, label.separation_thickness, true)
		begin_rads += rads_from_begin_angle
