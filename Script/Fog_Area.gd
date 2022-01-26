extends Area2D



func _ready():
	pass 

#func _process(delta):
#	pass

func _on_Fog_Area_body_entered(body):
	if body.name == "Player":
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimationPlayer.play("apear")



func _on_Fog_Area_body_exited(body):
	if body.name == "Player":
		yield(get_tree().create_timer(0.8), "timeout")
		$AnimationPlayer.play("disapear")

