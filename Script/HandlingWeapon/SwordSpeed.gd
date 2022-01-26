extends Position2D


var speed = 0
onready var pre_pos = global_position

# Update previous position per every 0.005 seconds
func _on_Timer_timeout():
	pre_pos = global_position

func _physics_process(_delta):
	speed = (pre_pos - global_position).length()
