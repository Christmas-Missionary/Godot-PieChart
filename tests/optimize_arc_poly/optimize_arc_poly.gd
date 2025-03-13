extends Control

## Original (Except for nb_points and return value)
func ori(center, radius, angle_from, angle_to, _color, nb_points):
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	return points_arc

## Func I want to improve
func fone(center: Vector2, radius: float, angle_from: float, angle_to: float, _color, number_of_points: int) -> PackedVector2Array:
	var points_arc: PackedVector2Array = [center]
	for i: int in (number_of_points + 1):
		points_arc.push_back(Vector2.from_angle(deg_to_rad((((angle_to - angle_from) * i) / number_of_points) + angle_from)) * radius + center)
	return points_arc

## with Vector2.rotated()
func ftwo(center: Vector2, radius: float, angle_from: float, angle_to: float, _color, number_of_points: int) -> PackedVector2Array:
	var points_arc: PackedVector2Array = [center, Vector2.from_angle(deg_to_rad(angle_from)) * radius + center]
	var rads_to_rotate: float = deg_to_rad(angle_to - angle_from) / number_of_points
	for i: int in range(1, number_of_points + 1):
		points_arc.push_back((points_arc[i] - center).rotated(rads_to_rotate) + center)
	return points_arc

## Ditched degrees for radians
func fthree(center: Vector2, radius: float, rads_from: float, rads_to: float, _color, number_of_points: int) -> PackedVector2Array:
	var points_arc: PackedVector2Array = [center, Vector2.from_angle(rads_from) * radius + center]
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	for i: int in range(1, number_of_points + 1):
		points_arc.push_back((points_arc[i] - center).rotated(rads_to_rotate) + center)
	return points_arc

## Resized array ahead of time
func ffour(center: Vector2, radius: float, rads_from: float, rads_to: float, _color, number_of_points: int) -> PackedVector2Array:
	var points_arc: PackedVector2Array = [center, Vector2.from_angle(rads_from) * radius + center]
	points_arc.resize(number_of_points + 2)
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	for i: int in range(2, number_of_points + 2):
		points_arc[i] = (points_arc[i - 1] - center).rotated(rads_to_rotate) + center
	return points_arc

func ffive(center: Vector2, radius: float, rads_from: float, rads_to: float, _color, number_of_points: int) -> PackedVector2Array:
	var points_arc: PackedVector2Array = [center, Vector2.from_angle(rads_from) * radius + center]
	points_arc.resize(number_of_points + 2)
	var rads_to_rotate: float = (rads_to - rads_from) / number_of_points
	var last_vec: Vector2 = points_arc[1]
	for i: int in range(2, number_of_points + 2):
		last_vec = (last_vec - center).rotated(rads_to_rotate) + center
		points_arc[i] = last_vec
	return points_arc

var time: int = 0

func _ready() -> void:
	const TAU_KINDOF: float = 6.28317
	print("Accuracy Test\n")
	var arr_ori: PackedVector2Array = ori(Vector2.ONE * 310, 300, 0, 359.999, Color.WHITE, 64)
	var arr_one: PackedVector2Array = fone(Vector2.ONE * 310, 300, 0, 359.999, Color.WHITE, 64)
	var arr_two: PackedVector2Array = ftwo(Vector2.ONE * 310, 300, 0, 359.999, Color.WHITE, 64)
	var arr_three: PackedVector2Array = fthree(Vector2.ONE * 310, 300, 0, TAU_KINDOF, Color.WHITE, 64)
	var arr_four: PackedVector2Array = ffour(Vector2.ONE * 310, 300, 0, TAU_KINDOF, Color.WHITE, 64)
	var arr_five: PackedVector2Array = ffive(Vector2.ONE * 310, 300, 0, TAU_KINDOF, Color.WHITE, 64)
	assert(arr_ori.size() == arr_one.size() && arr_one.size() == arr_two.size() && arr_one.size() == arr_three.size()
	&& arr_one.size() == arr_four.size() && arr_four.size() == arr_five.size(), "Sizes do not match!")
	for i: int in arr_one.size():
		print("Array 1: ", arr_one[i], " Difference Between 1 and original: ", arr_ori[i] - arr_one[i], " Difference Between 2 and 1: ", arr_two[i] - arr_one[i],
		" Difference Between 3 and 2: ", arr_three[i] - arr_two[i], " Difference Between 4 and 3: ",
		arr_four[i] - arr_three[i], " Difference Between 5 and 4: ", arr_five[i] - arr_four[i])
	
	print("\nSpeed Test\n")
	const _SAMPLE_SIZE: int = 50000
	Callable().bindv([])
	const ARGS_ONE: Array = [Vector2.ONE * 310, 300, 0, 359.999, Color.WHITE, 1280]
	const ARGS_TWO: Array = [Vector2.ONE * 310, 300, 0, TAU_KINDOF, Color.WHITE, 1280]
	
	for fun: Callable in [ori.bindv(ARGS_ONE), fone.bindv(ARGS_ONE), ftwo.bindv(ARGS_ONE), fthree.bindv(ARGS_TWO), ffour.bindv(ARGS_TWO), ffive.bindv(ARGS_TWO)] as Array[Callable]:
		time = Time.get_ticks_usec()
		for i: int in _SAMPLE_SIZE:
			fun.call()
		time = Time.get_ticks_usec() - time
		print("Function " , fun.get_method(), " took ", time, " microseconds.")
