extends RichTextLabel

func _ready() -> void:
	_on_h_slider_value_changed(1.0)

func _on_h_slider_value_changed(value: float) -> void:
	text = "[center]multiplier value: %.3f" % value
