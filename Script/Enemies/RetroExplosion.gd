extends Particles2D


func _ready():
	emitting = true

func _exit_tree():
	self.queue_free()
