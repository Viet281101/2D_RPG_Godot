extends CanvasLayer

onready var stats = PlayerStats

func _on_TextureButton_pressed():
	queue_free()
	get_tree().quit()

