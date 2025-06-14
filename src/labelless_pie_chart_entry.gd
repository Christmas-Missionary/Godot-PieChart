class_name LabellessPieChartEntry extends Resource
## Resource for a unit of data on a labelless pie chart.
##
## This is used to store a singular entry, and can be represented as a slice if in an [code]Array[LabellessPieChartEntry][/code] via [member LabellessPieChart.all_entries]

## Does [b]not have to be[/b] a percentage from 0 to 100, as the [LabellessPieChart] calculates that with all [LabellessPieChartEntry] elements in the all_entries array.
## However, the weight must be a positive value (at least zero).
@export_range(0, 2 ** 64) var weight: float = 1.0:
	set(val):
		assert(weight >= 0.0, "The `weight` from a LabellessPieChartEntry is supposed to be at least zero!")
		weight = val

## Used as the Color drawn and displayed for the [LabellessPieChart].
@export var color: Color = Color.BLACK

## How thick the separator should be if on. Set this value to 0.0 to turn it off.
@export_range(0, 1000) var separation_thickness: float = 0.0

## What color the separator should be if on.
@export var separation_color: Color = Color.WHITE

func _init(weight_: float = 1.0, color_: Color = Color.BLACK, separation_size: float = 0.0, separation_color_: Color = Color.WHITE) -> void:
	weight = weight_
	color = color_
	separation_thickness = separation_size
	separation_color = separation_color_
