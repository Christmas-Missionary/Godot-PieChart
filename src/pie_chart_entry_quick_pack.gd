class_name PieChartEntryQuickPack extends Resource
## An entry pack but you don't want to set the colors yourself. 
##
## This a resource where the names and weights are in a dictionary, and the colors are generated with a starting color and callable.
## Use this if you want some sort of pattern with your colors.

## A dictionary for names and weights. [b]Hopefully, you have different strings for each key![/b]
@export var values: Dictionary[String, float] = {}

## The function that changes the color for the next entry.[br][br]
## [b]Note:[/b] It is not recommended for this to change global state, but it can depend on global state if needed.
@export var color_changer: Callable = Callable()

## The color that will be in the first element of the array.
@export var starting_color: Color = Color.BLACK

func _init(vals: Dictionary[String, float] = {}, _color_changer: Callable = func(val: Color) -> Color: return val, _starting_color: Color = Color()) -> void:
	values = vals
	color_changer = _color_changer
	starting_color = _starting_color

## Returns an array of entries with the generated colors.
func to_array() -> Array[PieChartEntry]:
	if (color_changer.call(starting_color) is not Color):
		push_error("Color Changer does NOT return a color!")
		return []
	
	var names: Array[String] = values.keys() as Array[String]
	var weights: Array[float] = values.values() as Array[float]
	var res: Array[PieChartEntry]
	var err: int = res.resize(values.size())
	assert(err == Error.OK, "Array couldn't be resized!")
	var color_generated: Color = starting_color
	for i: int in values.size():
		res[i] = PieChartEntry.new(names[i], weights[i], color_generated)
		@warning_ignore("unsafe_cast")
		color_generated = color_changer.call(color_generated) as Color
	return res

## Returns a dictionary of entries for strings given the text formatting for each label.
func with_formatting(formatting: Array[String]) -> Dictionary[PieChartEntry, String]:
	if (color_changer.call(starting_color) is not Color):
		push_error("Color Changer does NOT return a color!")
		return {}
	assert(formatting.size() == values.size(), "Sizes of the number of strings in `formatting` is not the same as the number of the property `values`!")
	
	var names: Array[String] = values.keys() as Array[String]
	var weights: Array[float] = values.values() as Array[float]
	var res: Dictionary[PieChartEntry, String]
	var color_generated: Color = starting_color
	for i: int in values.size():
		res[PieChartEntry.new(names[i], weights[i], color_generated)] = formatting[i]
		@warning_ignore("unsafe_cast")
		color_generated = color_changer.call(color_generated) as Color
	return res
