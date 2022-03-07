class_name DayNightCycle
extends CanvasModulate

signal day_tick(day)

const NIGHT_COLOR = Color("#000000")
const DAY_COLOR = Color("#110000")
const EVENING_COLOR = Color("#bbbbbb")
const TIME_SCALE = 0.05

var time = 0
var last_day = 0

func _process(delta:float) -> void:
	self.time += delta * TIME_SCALE
	var value = (sin(time) + 1) / 2
	self.color = get_source_colour(value).linear_interpolate(get_target_colour(value), value)
	var new_day = _get_day()
	if new_day != last_day:
		last_day = new_day
		emit_signal("day_tick", new_day)
		
func get_source_colour(value):
	return NIGHT_COLOR.linear_interpolate(EVENING_COLOR, value)

func get_target_colour(value):
	return EVENING_COLOR.linear_interpolate(DAY_COLOR, value)
	
func _get_day() -> int:
	# this is required as midnight is not perfectly dark
	var offset = 0.15
	return 1 + int(offset + ceil(0.5 * time) / PI)

