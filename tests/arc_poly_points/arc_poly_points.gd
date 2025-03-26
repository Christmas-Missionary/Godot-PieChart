extends Control
const _POS: Vector2i = Vector2i(305, 305)
const _RADIUS: int = 300

var _points: int = 3

@onready var _label: Label = $Label as Label

func draw_circle_arc_poly(center: Vector2, radius: float, rads_from: float, rads_to: float, color: Color, number_of_points: int) -> void:
	var previous_vec: Vector2 = Vector2.from_angle(rads_from) * radius
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	var points_arc: PackedVector2Array
	var err: int = points_arc.resize(number_of_points + 2)
	assert(err == 0, "Something horribly wrong has happened!")
	points_arc[0] = center
	points_arc[1] = previous_vec + center
	for i: int in range(2, number_of_points + 2):
		previous_vec = previous_vec.rotated(rads_to_rotate)
		points_arc[i] = previous_vec + center
	draw_colored_polygon(points_arc, color)

func _ready() -> void:
	_label.text = str(_points)

func _draw() -> void:
	const TAU_KINDOF: float = 6.28317
	draw_circle(_POS, _RADIUS, Color.RED)
	draw_circle_arc_poly(_POS, _RADIUS, 0, TAU_KINDOF, Color.WHITE, _points)
	await RenderingServer.frame_post_draw
	var image: Image = get_viewport().get_texture().get_image()
	var whites: int = 0
	var reds: int = 0
	for x: int in range(_POS.x - _RADIUS, _POS.x + _RADIUS + 1):
		for y: int in range(_POS.y - _RADIUS, _POS.y + _RADIUS + 1):
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
