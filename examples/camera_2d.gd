extends Camera2D

func _ready() -> void:
	var vector: Vector2i = (get_parent() as ColorRect).size
	limit_right = vector.x
	limit_bottom = vector.y

func _physics_process(_delta: float) -> void:
	const _SPEED: float = 10.0
	if Input.is_action_pressed(&"ui_up"):
		position.y -= _SPEED
	elif Input.is_action_pressed(&"ui_down"):
		position.y += _SPEED
	if Input.is_action_pressed(&"ui_left"):
		position.x -= _SPEED
	elif Input.is_action_pressed(&"ui_right"):
		position.x += _SPEED
	position = position.clamp(Vector2(574, 300), Vector2(limit_right - 574, limit_bottom - 300))
