extends Control

# A key is the name of the entry, while a value is the weight on the chart
@export var entries: Dictionary[String, float]
@export var title: String
@export var show_title: bool = true
@export var show_separation: bool = false

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_colored_polygon(points_arc, color)

func _draw():
	for i in $Labels.get_children():
		i.free()
	var center = Vector2(size.x / 2, size.y / 2)
	var radius = min(size.x, size.y) / 4 
	var previous_angle: float = 0
	var counter: int = 0
	var values_size: int = entries.values().filter(func(number): return number > 0).size() 
	var total: float = entries.values().reduce(func sum(accum, number): return accum + number, 0)
	if !entries:
		push_error("There are no entries to display!")
	elif total == 0:
		push_error("All the entries total zero!")
	for i in entries:
		assert(entries[i] >= 0.0, "Individual value must be at least zero!")
		# Chosing color
		var color: Color = Color.from_hsv(1.0 / (values_size + 1) * counter / 2 if counter % 2 == 0 else 1.0 / (values_size + 1) * (values_size - counter / 2), 0.6 if counter % 4 < 2 else 0.8, 0.9)
		counter += 1
		# Drawing on the screen
		var percentage: float = entries[i] / (total / 100)
		var current_angle: float = 360 * (percentage / 100)
		var angle := deg_to_rad(current_angle + previous_angle)
		var angle_point: Vector2 = Vector2(cos(angle - deg_to_rad(current_angle / 2)), sin(angle - deg_to_rad(current_angle/2))) * radius
		var label = Label.new()
		label.text = i + "\n" + str(snappedf(percentage, 0.01)).pad_decimals(2) + "%"
		label.vertical_alignment = 1
		label.horizontal_alignment = 1
		$Labels.add_child(label)
		label.position = center - label.size / 2 + angle_point * 1.5
		draw_line(angle_point * 1.05 + center, angle_point * 1.2 + center, Color.WHITE, 2, true)
		draw_circle_arc_poly(center, radius, previous_angle, previous_angle + current_angle, color)
		if show_separation:
			draw_line(center, center + Vector2(cos(angle), sin(angle)) * radius, Color.WHITE, 2, true)
		previous_angle += current_angle
	var title_label := $TitleLabel
	if show_title:
		title_label.visible = true
		draw_circle(center, radius * 0.60, Color.WHITE)
		title_label.text = title
		title_label.size = Vector2(radius, radius) 
		title_label.position = center - title_label.size / 2
	else:
		title_label.visible = false
