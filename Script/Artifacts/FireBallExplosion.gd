extends Node2D


func _ready():
	$AnimationPlayer.play("explosion")

#func _process(delta):
#	pass

func _explosion_finish():
	queue_free()
