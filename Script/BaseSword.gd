extends Area2D


func _ready():
	pass

func _on_Area2D_area_entered(area):
	if (area.is_in_group("Player")) and Input.is_action_just_pressed("ui_pick"):
		$Sword.visible = false
