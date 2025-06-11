extends PieChart

var _chart_index: int = 0
const _STARTING_YEAR: int = 860

var _all_entries: Array[PieChartEntryPack] = [
	PieChartEntryPack.new([PieChartEntry.new("Doors", 96.0, Color.GREEN), PieChartEntry.new("Grapes", 3.0, Color.PURPLE), PieChartEntry.new("Adelie", 1.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 90.0, Color.GREEN), PieChartEntry.new("Grapes", 6.0, Color.PURPLE), PieChartEntry.new("Adelie", 4.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 85.0, Color.GREEN), PieChartEntry.new("Grapes", 10.0, Color.PURPLE), PieChartEntry.new("Adelie", 5.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 79.0, Color.GREEN), PieChartEntry.new("Grapes", 14.0, Color.PURPLE), PieChartEntry.new("Adelie", 7.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 60.0, Color.GREEN), PieChartEntry.new("Grapes", 17.0, Color.PURPLE), PieChartEntry.new("Adelie", 23.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 50.0, Color.GREEN), PieChartEntry.new("Grapes", 20.0, Color.PURPLE), PieChartEntry.new("Adelie", 30.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 46.0, Color.GREEN), PieChartEntry.new("Grapes", 22.0, Color.PURPLE), PieChartEntry.new("Adelie", 32.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 40.0, Color.GREEN), PieChartEntry.new("Grapes", 19.0, Color.PURPLE), PieChartEntry.new("Adelie", 41.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 35.0, Color.GREEN), PieChartEntry.new("Grapes", 18.0, Color.PURPLE), PieChartEntry.new("Adelie", 47.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 32.0, Color.GREEN), PieChartEntry.new("Grapes", 16.0, Color.PURPLE), PieChartEntry.new("Adelie", 52.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 28.0, Color.GREEN), PieChartEntry.new("Grapes", 15.0, Color.PURPLE), PieChartEntry.new("Adelie", 57.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 22.0, Color.GREEN), PieChartEntry.new("Grapes", 12.0, Color.PURPLE), PieChartEntry.new("Adelie", 66.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 16.0, Color.GREEN), PieChartEntry.new("Grapes", 10.0, Color.PURPLE), PieChartEntry.new("Adelie", 74.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 12.0, Color.GREEN), PieChartEntry.new("Grapes", 8.0, Color.PURPLE), PieChartEntry.new("Adelie", 81.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 7.0, Color.GREEN), PieChartEntry.new("Grapes", 7.0, Color.PURPLE), PieChartEntry.new("Adelie", 86.0, Color.RED)]),
	PieChartEntryPack.new([PieChartEntry.new("Doors", 4.0, Color.GREEN), PieChartEntry.new("Grapes", 9.0, Color.PURPLE), PieChartEntry.new("Adelie", 87.0, Color.RED)]),
]

var _formatting: Array[String] = ["%n\n%p", "%n\n%p", "%n\n%p"]

func _ready() -> void:
	_set_stuff()

func _on_timer_timeout() -> void:
	_chart_index = (_chart_index + 1) % _all_entries.size()
	_set_stuff()

func _set_stuff() -> void:
	var __: PieChart = with_labels(PieChartEntry.with_formatting(_all_entries[_chart_index].array_of_entries, _formatting), true)
	get_title_label().set_label("(Fictional)\nDesktop\nMarketshare\nYear: %d" % (_STARTING_YEAR + _chart_index), Color.BLACK, 58)
