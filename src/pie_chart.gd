extends Control
class_name PieChart
enum ENTRY_MODE {ENTRY_ARRAY, ENTRY_PACK, QUICK_ENTRY_PACK}

@export_group("Entry", "entries_")
@export var entries_mode: ENTRY_MODE:
	set(val):
		entries_mode = val
		queue_redraw()

@export var entries_array: Array[PieChartEntry]:
	set(val):
		entries_array = val
		if entries_mode == ENTRY_MODE.ENTRY_ARRAY:
			queue_redraw()
	get():
		if entries_mode == ENTRY_MODE.ENTRY_ARRAY:
			queue_redraw()
		return entries_array

@export var entries_pack: PieChartEntryPack:
	set(val):
		entries_pack = val
		if entries_mode == ENTRY_MODE.ENTRY_PACK:
			queue_redraw()
	get():
		if entries_mode == ENTRY_MODE.ENTRY_PACK:
			queue_redraw()
		return entries_pack

@export var entries_quick_values: PieChartEntryQuickPack:
	set(val):
		entries_quick_values = val
		if entries_mode == ENTRY_MODE.QUICK_ENTRY_PACK:
			queue_redraw()
	get():
		if entries_mode == ENTRY_MODE.QUICK_ENTRY_PACK:
			queue_redraw()
		return entries_quick_values

@export_group("Slices")
@export_range(0, 10) var chart_radius_multiplier: float = 1.0: 
	set(val):
		assert(chart_radius_multiplier >= 0, "Someone changed the range of `chart_radius_multiplier` in PieChart!")
		chart_radius_multiplier = val
		queue_redraw()

@export_group("Label", "label_")
@export var label_show_name: bool = true:
	set(val):
		label_show_name = val
		queue_redraw()

@export var label_show_weights: bool = true:
	set(val):
		label_show_weights = val
		queue_redraw()

@export var label_show_percentage: bool = true:
	set(val):
		label_show_percentage = val
		queue_redraw()

@export var label_is_in_slice: bool:
	set(val):
		label_is_in_slice = val
		queue_redraw()

@export_group("Separation", "separation_")
@export var separation_show: bool:
	set(val):
		separation_show = val
		queue_redraw()

@export var separation_color: Color:
	set(val):
		separation_color = val
		queue_redraw()

@export_range(0, 1000) var separation_thickness: float:
	set(val):
		assert(separation_thickness >= 0, "Someone changed the range of `separation_thickness` in PieChart!")
		separation_thickness = val
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

func _weight_sum(arr: Array[PieChartEntry]) -> float:
	var res: float = 0
	for elem: PieChartEntry in arr:
		res += elem.weight
	return res

func _entry_quick_pack_to_arr(quick_pack: PieChartEntryQuickPack) -> Array[PieChartEntry]:
	var names: Array[String] = quick_pack.values.keys() as Array[String]
	var weights: Array[float] = quick_pack.values.values() as Array[float]
	
	var r_inc: int
	var g_inc: int
	var b_inc: int
	
	match quick_pack.color_scale:
		PieChartEntryQuickPack.COLOR_SCALE.GREY_SCALE:
			r_inc = 50
			g_inc = 50
			b_inc = 50
	
	var res: Array[PieChartEntry]
	var err: int = res.resize(quick_pack.values.size())
	assert(err == Error.OK, "Something horribly wrong has happened!")
	var color_generated: Color
	for i: int in quick_pack.values.size():
		res[i] = PieChartEntry.new(names[i], weights[i], color_generated)
		color_generated.r8 += r_inc
		color_generated.g8 += g_inc
		color_generated.b8 += b_inc
	return res

func _draw() -> void:
	var label_nodes: Array[Node] = get_children().filter(func(node: Node) -> bool: return node is Label) as Array[Node]
	var all_entries: Array[PieChartEntry] = (
		entries_array if entries_mode == ENTRY_MODE.ENTRY_ARRAY else 
		entries_pack.array_of_entries if entries_mode == ENTRY_MODE.ENTRY_PACK else
		_entry_quick_pack_to_arr(entries_quick_values)
	)
	var size_of_entries: int = all_entries.size()
	if size_of_entries < label_nodes.size():
		for i: int in (label_nodes.size() - size_of_entries):
			label_nodes[i].queue_free()
	elif size_of_entries > label_nodes.size():
		for _i: int in (size_of_entries - label_nodes.size()):
			add_child(preload("res://src/entry_label.tscn").instantiate())
	var hundredth_of_total: float = _weight_sum(all_entries) * 0.01
	if !all_entries:
		push_error("There are no entries to display!")
	elif hundredth_of_total == 0:
		push_error("All the entries total zero!")
	var center: Vector2 = size / 2
	var radius: float = (minf(size.x, size.y) / 4) * chart_radius_multiplier
	var begin_rads: float = 0
	label_nodes = get_children().filter(func(node: Node) -> bool: return node is Label && !node.is_queued_for_deletion()) as Array[Node]
	var number_of_points: int = ceili(64.0 / size_of_entries)
	var separation_angles: PackedFloat64Array
	var err: int = separation_angles.resize(size_of_entries) # DO NOT put this line inside assert
	assert(err == Error.OK, "Something horribly wrong has happened!")
	for i: int in size_of_entries:
		
		var entry: PieChartEntry = all_entries[i]
		
		var percentage: float = entry.weight / hundredth_of_total
		var rads_from_begin_angle: float = percentage * 0.0628318530717959 # (TAU * 0.01)
		var sum_of_rads: float = rads_from_begin_angle + begin_rads
		
		# To EntryLabel Class somehow maybe? draw_line only works in it's own _draw()
		var label: Label = label_nodes[i] as Label
		label.text = (
			("Name: %s\n" % entry.name if label_show_name else "") +
			("Weight: %.2f\n" % entry.weight if label_show_weights else "") +
			("Percentage: %.2f%%\n" % percentage if label_show_percentage else "")
		)
		var label_angle_point: Vector2 = Vector2.from_angle(sum_of_rads - (rads_from_begin_angle / 2)) * radius
		label.position = (label_angle_point * (0.5 if label_is_in_slice else 1.7)) + center - (label.size / 2)
		if label.text != "" and !label_is_in_slice:
			draw_line((label_angle_point * 1.05) + center, (label_angle_point * 1.2) + center, Color.WHITE, 2, true)
		
		_draw_circle_arc_poly(center, radius, begin_rads, begin_rads + rads_from_begin_angle, entry.color, number_of_points)
		separation_angles[i] = sum_of_rads
		begin_rads += rads_from_begin_angle
	if separation_show:
		for angle: float in separation_angles:
			draw_line(center, Vector2.from_angle(angle) * radius + center, separation_color, separation_thickness, true)
