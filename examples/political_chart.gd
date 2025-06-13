extends LabellessPieChart

enum DRIFT_TYPE {NONE, RED_PARTY, BLUE_PARTY}
var _current_drift_type: DRIFT_TYPE = _rand_type()
var _current_drift_amount: float = randf_range(-5, 5)

var _elapses_since_last_change: int = 0

func _rand_type() -> DRIFT_TYPE:
	match randi_range(0, 2):
		1: return DRIFT_TYPE.RED_PARTY
		2: return DRIFT_TYPE.BLUE_PARTY
		_: return DRIFT_TYPE.NONE

func _ready() -> void:
	all_entries = [LabellessPieChartEntry.new(100, Color.GRAY, 8.0), LabellessPieChartEntry.new(100, Color.RED, 8.0), LabellessPieChartEntry.new(100, Color.BLUE, 8.0)]

func _elapse() -> void:
	all_entries[_current_drift_type].weight = maxf(0, all_entries[_current_drift_type].weight + _current_drift_amount)
	_elapses_since_last_change += 1
	if _elapses_since_last_change >= 10:
		_elapses_since_last_change = 0
		_current_drift_type = _rand_type()
		_current_drift_amount = randf_range(-5, 5)
