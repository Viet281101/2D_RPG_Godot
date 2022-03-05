extends Particles2D


func _ready():
	emitting = true
	$Timer.start()


func _exit_tree():
	self.queue_free()


func _on_Timer_timeout():
	queue_free()
