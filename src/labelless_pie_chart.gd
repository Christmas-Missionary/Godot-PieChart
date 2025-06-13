extends Control
class_name LabellessPieChart

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
