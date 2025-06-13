extends PieChart

var _rotation_speed: float = 0.02

func _physics_process(_delta: float) -> void:
	starting_offset_radians = wrapf(starting_offset_radians + _rotation_speed, 0.0, TAU)
