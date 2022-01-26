extends Area2D

export(int) var id = 0

var lockPortal = false

func LockedPortal():
	lockPortal = true
	yield(get_tree().create_timer(1.0), "timeout")
	lockPortal = false

func _ready():
	pass 

func _process(_delta):
	if lockPortal == true:
		$AnimationPlayer.play("Active")
	else:
		$AnimationPlayer.play("Idle")
