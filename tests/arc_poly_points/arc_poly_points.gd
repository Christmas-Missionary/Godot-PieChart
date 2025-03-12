extends Control
const _POS: Vector2i = Vector2i(305, 305)
const _RADIUS: int = 300

var _points: int = 3

@onready var _label: = $Label as Label

func draw_circle_arc_poly(center: Vector2, radius: float, angle_from: float, angle_to: float, color: Color, number_of_points: int):
	var points_arc: PackedVector2Array = [center]
	for i: int in (number_of_points + 1):
		points_arc.push_back(Vector2.from_angle(deg_to_rad((((angle_to - angle_from) * i) / number_of_points) + angle_from)) * radius + center)
	draw_colored_polygon(points_arc, color)

func _ready() -> void:
	_label.text = str(_points)

func _draw() -> void:
	draw_circle(_POS, _RADIUS, Color.RED)
	draw_circle_arc_poly(_POS, _RADIUS, 0, 359.999, Color.WHITE, _points)
	await RenderingServer.frame_post_draw
	var image: Image = get_viewport().get_texture().get_image()
	var whites: int = 0
	var reds: int = 0
	for x in range(_POS.x - _RADIUS, _POS.x + _RADIUS + 1):
		for y in range(_POS.y - _RADIUS, _POS.y + _RADIUS + 1):
			var color: Color = image.get_pixel(x, y)
			if color == Color.RED:
				reds += 1
			elif color == Color.WHITE:
				whites += 1
	print(_points, " points -> (", whites, " whites, ", reds, " reds), -> ", (whites * 100.0) / (whites + reds), "% of all pixels in circle are white.")

func _on_h_slider_value_changed(value: float) -> void:
	_points = int(value)
	_label.text = str(_points)
	queue_redraw()
