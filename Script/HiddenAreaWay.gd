extends Area2D


func _ready():
	pass


func _on_HiddenAreaWay_body_entered(body):
	if body.name == "Player":
		$Sprite.modulate = Color(0, 0, 0, 10)
		$Sprite.visible = false


func _on_HiddenAreaWay_body_exited(body):
	if body.name == "Player":
		$Sprite.modulate = Color(255, 255, 255, 255)
		$Sprite.visible = true
