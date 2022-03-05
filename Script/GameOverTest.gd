extends CanvasLayer

onready var stats = PlayerStats

func _ready():
	Global.can_pause = false

func _on_TextureButton_pressed():
	queue_free()
	get_tree().quit()

func _exit_tree():
	self.queue_free()
