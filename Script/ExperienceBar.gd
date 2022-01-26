tool
extends TextureProgress

var stats = PlayerStats

func initialized(current, maximum):
	max_value = maximum
	value = current


func _on_Player_experience_gained(growth_data):
	for line in growth_data:
		var target_experience = line[0]
		var max_experience = line[1]
		max_value = max_experience
		yield(animate_value(target_experience), "completed")
		if abs(max_value - value) < 0.01:
			value = min_value

func animate_value(target, tween_duration = 1.0):
	$Tween.interpolate_property(self, 'value', value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")

func _ready():
	pass
