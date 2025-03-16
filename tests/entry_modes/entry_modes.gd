extends Control

func _on_timer_timeout() -> void:
	var _sub: = $Subject as PieChart
	_sub.entries_mode = (_sub.entries_mode + 1) % 3
