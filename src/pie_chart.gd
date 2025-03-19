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

@export var entries_pack: EntryPack:
	set(val):
		entries_pack = val
		if entries_mode == ENTRY_MODE.ENTRY_PACK:
			queue_redraw()
	get():
		if entries_mode == ENTRY_MODE.ENTRY_PACK:
			queue_redraw()
		return entries_pack

@export var entries_quick_values: EntryQuickPack:
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

var _title_label: RichTextLabel = preload("res://src/title_label.tscn").instantiate() as RichTextLabel

@export_group("Title", "title_")
@export var title_text: String:
	set(val):
		title_text = val
		if title_show:
			queue_redraw()

@export var title_circle_color: Color:
	set(val):
		title_circle_color = val
		if title_show:
			queue_redraw()

@export_range(0, 1000) var title_circle_radius: float:
	set(val):
		assert(title_circle_radius >= 0, "Someone changed the range of `title_circle_radius` in PieChart!")
		title_circle_radius = val
		if title_show:
			queue_redraw()

@export var title_show: bool = true:
	set(val):
		title_show = val
		queue_redraw()

@export var title_bbcode_enabled: bool:
	set(val):
		title_bbcode_enabled = val
		_title_label.bbcode_enabled = val
		if title_show:
			queue_redraw()

var _entry_label_parent: Control = preload("res://src/labels.tscn").instantiate() as Control

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
	add_child(_title_label, false, Node.INTERNAL_MODE_FRONT)
	add_child(_entry_label_parent, false, Node.INTERNAL_MODE_FRONT)

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

func _entry_quick_pack_to_arr(quick_pack: EntryQuickPack) -> Array[PieChartEntry]:
	var names: Array[String] = quick_pack.values.keys() as Array[String]
	var weights: Array[float] = quick_pack.values.values() as Array[float]
	
	var r_inc: int
	var g_inc: int
	var b_inc: int
	
	match quick_pack.color_scale:
		EntryQuickPack.COLOR_SCALE.GREY_SCALE:
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
	const LABEL: PackedScene = preload("res://src/entry_label.tscn")
	var label_nodes: Array[Node] = _entry_label_parent.get_children()
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
			_entry_label_parent.add_child(LABEL.instantiate())
	var total: float = _weight_sum(all_entries)
	if !all_entries:
		push_error("There are no entries to display!")
	elif total == 0:
		push_error("All the entries total zero!")
	var center: Vector2 = size / 2
	var radius: float = (minf(size.x, size.y) / 4) * chart_radius_multiplier
	var previous_angle: float = 0
	label_nodes = _entry_label_parent.get_children().filter(func(val: Node) -> bool: return !val.is_queued_for_deletion()) as Array[Node]
	var number_of_points: int = ceili(64.0 / size_of_entries)
	var separation_angles: PackedFloat64Array
	var err: int = separation_angles.resize(size_of_entries)
	assert(err == Error.OK, "Something horribly wrong has happened!")
	for i: int in size_of_entries:
		var entry: PieChartEntry = all_entries[i]
		# Drawing on the screen
		var percentage: float = entry.weight / (total * 0.01)
		var current_angle: float = percentage * 0.0628318530717959 # (TAU * 0.01)
		var angle: float = current_angle + previous_angle
		var angle_point: Vector2 = Vector2.from_angle(angle - (current_angle / 2)) * radius
		var label: Label = label_nodes[i] as Label
		label.text = (
			("Name: %s\n" % entry.name if label_show_name else "") +
			("Weight: %.2f\n" % entry.weight if label_show_weights else "") +
			("Percentage: %.2f%%\n" % percentage if label_show_percentage else "")
		)
		label.position = (angle_point * (0.5 if label_is_in_slice else 1.7)) + center - (label.size / 2)
		if label.text != "" and !label_is_in_slice:
			draw_line((angle_point * 1.05) + center, (angle_point * 1.2) + center, Color.WHITE, 2, true)
		_draw_circle_arc_poly(center, radius, previous_angle, previous_angle + current_angle, entry.color, number_of_points)
		separation_angles[i] = angle
		previous_angle += current_angle
	if separation_show:
		for angle: float in separation_angles:
			draw_line(center, Vector2.from_angle(angle) * radius + center, separation_color, separation_thickness, true)
	_title_label.visible = title_show
	if title_show:
		draw_circle(center, title_circle_radius, title_circle_color)
		_title_label.text = title_text
		_title_label.set_deferred(&"size", Vector2.ONE * radius)
		_title_label.position = center - (Vector2.ONE * radius / 2)
