class_name PieChartEntryLabel extends RichTextLabel
## A control for a [PieChartEntry] and how it's displayed.
## 
## [b]Note:[/b] This control only works if it has a [PieChart] as a parent. [br][br]
##
## [color=red][b]Note:[/b] If you need to override [method Node._ready], make sure to call [code]super()[/code] first![/color]
## [codeblock]
## func _ready() -> void:
##    super()
##    # All other stuff
## [/codeblock]

## Used to connect to [method CanvasItem.queue_redraw] through the parent [PieChart]. This fires when any of the new [PieChartEntryLabel] properties change.
signal property_changed

## This is the most important property for this node.
## If you are just looking for text by a [PieChart] with no direct interaction from the [PieChart], use [RichTextLabel] or [Label].
@export var entry: PieChartEntry = null:
	set(val):
		entry = val
		property_changed.emit()
	get():
		property_changed.emit()
		return entry

## Every time the parent [PieChart] draws, it tells the [PieChartEntryLabel] children to set [member RichTextLabel.text] in accordance to [member PieChartEntryLabel.text_format].[br][br]
## Like the % operator for a [String], you have 4 formatters to choose from: [br]
## [code]%n[/code] for the name of the entry.[br]
## [code]%w[/code] for the weight of the entry.[br]
## [code]%p[/code] for the percentage, usually given by the parent [PieChart].[br]
## [code]%%[/code] for the ASCII character of [code]%[/code]. Though, you don't need this right after [code]%p[/code].[br]
## For Example:
## [codeblock]
## extends PieChartEntryLabel
##
## ## This is in an entry along with 3 others as children to a PieChart, all with weights of 1.0.
##func _ready() -> void:
##    entry = PieChartEntry.new("John", 1.0, Color.DIM_GRAY)
##    text_format = "%n\n%p%w" 
##    # text becomes "John\n25.00%1.0"
## [/codeblock]
@export_multiline var text_format: String = "":
	set(val):
		text_format = val
		property_changed.emit()

## A boolean for whether or not the weight should be integer. This is useful if weights are whole numbers (i.e. [code]2.0[/code]).
@export var display_weight_as_integer: bool = false:
	set(val):
		display_weight_as_integer = val
		property_changed.emit()

## if [code]true[/code], the [PieChart] will ignore this label.
@export var disabled: bool = false:
	set(val):
		disabled = val
		visible = !val
		property_changed.emit()

## if [code]true[/code], the label will be inside the slice as opposed to outside with a line drawn to it.
@export var is_in_slice: bool = false:
	set(val):
		is_in_slice = val
		property_changed.emit()

@export_group("Separation", "separation_")
## Is whether or not the label should have a separator at its end.
@export var separation_show: bool = false:
	set(val):
		separation_show = val
		property_changed.emit()

## What color the separator should be if on.
@export var separation_color: Color = Color.WHITE:
	set(val):
		separation_color = val
		property_changed.emit()

## How thick the separator should be if on.
@export_range(0, 1000) var separation_thickness: float = 3.0:
	set(val):
		separation_thickness = val
		property_changed.emit()

func _ready() -> void:
	autowrap_mode = TextServer.AUTOWRAP_WORD
	mouse_filter = Control.MOUSE_FILTER_PASS
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	assert((get_parent() as PieChart), "Parent is not a PieChart!")
	var err: int = property_changed.connect((get_parent() as PieChart).queue_redraw)
	assert(err == Error.OK, "Couldn't connect signal!")

## Sets the entry and text formatting, and can be piped to something else.
func set_entry_and_format(_entry: PieChartEntry, format: String) -> PieChartEntryLabel:
	entry = _entry
	text_format = format
	return self

## Used by the parent [PieChart] to set the label. It sets the text, size, and position of the label, and can be piped to something else.
func set_to_display(percentage: float, center_pos: Vector2) -> PieChartEntryLabel:
	text = text_format.replace("%n", entry.name).replace("%w", ("%.0f\n" if display_weight_as_integer else "%.2f\n") % entry.weight).replace("%p", "%.2f%%\n" % percentage).replace("%%", "%")
	size = Vector2(get_content_width() + 30, get_content_height() + 30)
	position = center_pos - (size / 2)
	return self
