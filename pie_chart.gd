extends Control

# A key is the name of the entry, while a value is the weight on the chart
@export var entries: Dictionary[String, float]
@export var title: String
@export var show_title: bool = true
@export var show_separation: bool = false

func draw_circle_arc_poly(center: Vector2, radius: float, angle_from: float, angle_to: float, color: Color):
	const nb_points: int = 32
	var points_arc: PackedVector2Array = [center]
	for i in (nb_points + 1):
		var angle_point: float = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_colored_polygon(points_arc, color)

func _float_sum(arr: Array[float]) -> float:
	var res: float = 0
	for elem: float in arr:
		res += elem
	return res

func _draw():
	for node: Node in $Labels.get_children():
		node.free()
	var center: Vector2 = Vector2(size.x / 2, size.y / 2)
	var radius: float = minf(size.x, size.y) / 4 
	var previous_angle: float = 0
	var counter: int = 0
	var values_size: int = entries.values().filter(func(number: float) -> bool: return number > 0).size() 
	var total: float = _float_sum(entries.values())
	if !entries:
		push_error("There are no entries to display!")
	elif total == 0:
		push_error("All the entries total zero!")
	for entry_name: String in entries:
		assert(entries[entry_name] >= 0.0, "Individual value must be at least zero!")
		@warning_ignore("integer_division") # Chosing color, player will choose color soon
		var color: Color = Color.from_hsv(1.0 / (values_size + 1) * counter / 2 if counter % 2 == 0 else 1.0 / (values_size + 1) * (values_size - counter / 2), 0.6 if counter % 4 < 2 else 0.8, 0.9)
		counter += 1
		# Drawing on the screen
		var percentage: float = entries[entry_name] / (total / 100)
		var current_angle: float = 360 * (percentage / 100)
		var angle: float = deg_to_rad(current_angle + previous_angle)
		var angle_point: Vector2 = Vector2(cos(angle - deg_to_rad(current_angle / 2)), sin(angle - deg_to_rad(current_angle / 2))) * radius
		var label: Label = Label.new()
		label.text = entry_name + "\n" + str(snappedf(percentage, 0.01)).pad_decimals(2) + "%"
		label.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		$Labels.add_child(label)
		label.position = center - label.size / 2 + angle_point * 1.5
		draw_line(angle_point * 1.05 + center, angle_point * 1.2 + center, Color.WHITE, 2, true)
		draw_circle_arc_poly(center, radius, previous_angle, previous_angle + current_angle, color)
		if show_separation:
			draw_line(center, center + Vector2(cos(angle), sin(angle)) * radius, Color.WHITE, 2, true)
		previous_angle += current_angle
	var title_label: = $TitleLabel as Label
	if show_title:
		title_label.visible = true
		draw_circle(center, radius * 0.60, Color.WHITE)
		title_label.text = title
		title_label.size = Vector2(radius, radius) 
		title_label.position = center - title_label.size / 2
	else:
		title_label.visible = false
