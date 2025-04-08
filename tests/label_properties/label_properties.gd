extends Control

"""
Tests:
	PieChartEntryLabel
	All of its properties
"""

func _ready() -> void:
	var entries: PieChartEntryQuickPack = PieChartEntryQuickPack.new(
		{"One" : 1.0, "Two" : 1.0, "Three" : 1.0}, 
		func(color: Color) -> Color: return color.lerp(Color.WHITE, 0.1),
		Color.BLACK
	)
	var strings: Array[String] = [
		"%n\n%p%w%p",
		"[wave amp=-50]Name: %n\nWeight: %wPercentage %p",
		"[color=black]My name is %n\nand I have %p of the pie chart!",
	]
	($Subject as PieChart).set_entry_labels(entries.with_formatting(strings))
