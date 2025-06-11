class_name PieChartEntry extends Resource
## Resource for a unit of data on a pie chart.
##
## This is used to store a singular entry, and can be represented as a slice if in a [PieChartEntryLabel] with a [PieChart] parent.

## Used as the name of an entry.
@export var name: String = ""
## Does [b]not have to be[/b] a percentage from 0 to 100, as the [PieChart] calculates that with all [PieChartEntryLabel] nodes with an entry.
## However, the weight must be a positive value (at least zero).
@export_range(0, 2 ** 64) var weight: float = 1.0:
	set(val):
		assert(weight >= 0.0, "The `weight` from a PieChartEntry is supposed to be at least zero!")
		weight = val
## Used as the Color drawn and displayed on the parent [PieChart].
@export var color: Color = Color.BLACK

## This combines two arrays, one with entries, the other with strings for text formatting into a dictionary, helpful for [method PieChart.with_labels].
## [br]For Example:
## [codeblock]
##extends Control
##
##func _ready() -> void:
##    const ARRAY_SIZE: int = 100
##    var entries: Array[PieChartEntry]
##    var formatting: Array[String]
##
##    formatting.resize(ARRAY_SIZE)
##    formatting.fill("%n\n%p%w")
##
##    for i: int in ARRAY_SIZE:
##        entries.push_back(PieChartEntry.new("", 1.0, Color(randf(), randf(), randf())))
##
## (
##    PieChart.new()
##            .with_parent_as(self)
##            .set_position_and_size(Vector2(100.0, 50.0), Vector2(600.0, 600.0))
##            .with_labels(PieChartEntry.with_formatting(entries, formatting))
## )
## [/codeblock]
static func with_formatting(entries: Array[PieChartEntry], formatting: Array[String]) -> Dictionary[PieChartEntry, String]:
	if entries.size() != formatting.size():
		push_error("Sizes of entries and formatting do not match! Using smaller size.")
	var res: Dictionary[PieChartEntry, String]
	for i: int in mini(entries.size(), formatting.size()):
		res[entries[i]] = formatting[i]
	return res

func _init(name_: String = "", weight_: float = 1.0, color_: Color = Color.BLACK) -> void:
	name = name_
	weight = weight_
	color = color_
