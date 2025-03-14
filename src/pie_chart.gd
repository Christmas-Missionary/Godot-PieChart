extends Control
class_name PieChart

# A key is the name of the entry, while a value is the weight on the chart
@export var entries: Array[PieChartEntry]:
	set(val):
		entries = val
		queue_redraw()

@export var title: String:
	set(val):
		title = val
		queue_redraw()

@export var show_title: bool = true:
	set(val):
		show_title = val
		queue_redraw()

@export var show_separation: bool = false:
	set(val):
		show_separation = val
		queue_redraw()

# find number of points/sides needed for perfect circle
func draw_circle_arc_poly(center: Vector2, radius: float, rads_from: float, rads_to: float, color: Color, number_of_points: int) -> void:
	var previous_vec: Vector2 = Vector2.from_angle(rads_from) * radius
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	var points_arc: PackedVector2Array
	points_arc.resize(number_of_points + 2)
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

func _draw() -> void:
	const LABEL: PackedScene = preload("res://src/entry_label.tscn")
	var labels: Node = $Labels
	var size_of_entries: int = entries.size()
	if size_of_entries < labels.get_child_count():
		for i in (labels.get_child_count() - size_of_entries):
			labels.get_children()[i].queue_free()
	elif size_of_entries > labels.get_child_count():
		for _i in (size_of_entries - labels.get_child_count()):
			labels.add_child(LABEL.instantiate())
	var total: float = _weight_sum(entries)
	if !entries:
		push_error("There are no entries to display!")
	elif total == 0:
		push_error("All the entries total zero!")
	var center: Vector2 = size / 2
	var radius: float = minf(size.x, size.y) / 4
	var previous_angle: float = 0
	var all_labels: = labels.get_children().filter(func(val: Node) -> bool: return !val.is_queued_for_deletion()) as Array[Node]
	var number_of_points: int = ceili(64.0 / size_of_entries)
	for i: int in size_of_entries:
		var entry: PieChartEntry = entries[i]
		assert(entry.weight >= 0.0, "Individual value must be at least zero!")
		# Drawing on the screen
		var percentage: float = entry.weight / (total * 0.01)
		var current_angle: float = percentage * 0.0628318530717959 # (TAU * 0.01)
		var angle: float = current_angle + previous_angle
		var angle_point: Vector2 = Vector2.from_angle(angle - (current_angle / 2)) * radius
		var label: = all_labels[i] as Label
		label.text = "%s\n%.2f%%" % [entry.name, percentage]
		label.position = (angle_point * 1.5) + center - (label.size / 2)
		draw_line((angle_point * 1.05) + center, (angle_point * 1.2) + center, Color.WHITE, 2, true)
		draw_circle_arc_poly(center, radius, previous_angle, previous_angle + current_angle, entry.color, number_of_points)
		if show_separation:
			draw_line(center, Vector2.from_angle(angle) * radius + center, Color.WHITE, 2, true)
		previous_angle += current_angle
	var title_label: = $TitleLabel as Label
	title_label.visible = show_title
	if show_title:
		draw_circle(center, radius * 0.60, Color.WHITE)
		title_label.text = title
		title_label.size = Vector2.ONE * radius
		title_label.position = center - (title_label.size / 2)
