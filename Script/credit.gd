extends ColorRect

export (NodePath) onready var speed_slider = get_node(speed_slider) as HSlider
var speed = 0.5

func _ready():
	pass

func _process(_delta):
	if $TextCredit.rect_position.y >= -1300:
		_run_credit(speed)
	else:
		return 
#		$TextCredit.rect_position.y = 100

func _on_Return_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scene/MainMenu.tscn")
	Global.play_music()


func _on_HSlider_gui_input(event):
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
			speed = speed_slider.value

func _run_credit(value):
	$TextCredit.rect_position.y -= value
