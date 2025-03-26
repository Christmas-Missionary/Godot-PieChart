extends Control

func _ready() -> void:
	var entries: PieChartEntryQuickPack = PieChartEntryQuickPack.new(
		{"One" : 1.0, "Two" : 1.0, "Three" : 1.0},
		PieChartEntryQuickPack.COLOR_SCALE.GREY_SCALE
	)
	var strings: Array[String] = [
		"%n\n%p%w%p",
		"[wave amp=-50]Name: %n\nWeight: %wPercentage %p%%",
		"[color=black]My name is %n\nand I have %p of the pie chart!",
	]
	($Subject as PieChart).set_up_labels(PieChart.entry_quick_pack_to_arr(entries), strings)
