extends CanvasLayer

#var is_paused = false setget set_is_paused
onready var settingmenu = load("res://Scene/MenuGlobal.tscn")
onready var soundmenu = load("res://Scene/Music_Sound_Menu.tscn")
var arrow_cursor = load("res://assets/Items/arrow-cursor.png")


#func _unhandled_input(event):
#	if event.is_action_pressed("ui_pause"):
##		self.is_paused = !is_paused
#		Input.set_custom_mouse_cursor(arrow_cursor)

func _ready():
	Input.set_custom_mouse_cursor(arrow_cursor)

func _input(_event):
	if Input.is_key_pressed(KEY_ESCAPE) and Global.is_paused == false:
		queue_free()
		Global.is_paused = true
		get_tree().paused = false
	elif Input.is_key_pressed(KEY_SPACE) and Global.is_paused == false:
		queue_free()
		Global.is_paused = true
		get_tree().paused = false

#func set_is_paused(value):
#	is_paused = value
#	get_tree().paused = is_paused


func _on_Resume_pressed():
	queue_free()
#	self.is_paused = !is_paused
	Global.is_paused = true
	get_tree().paused = false


func _on_Quit_pressed():
	queue_free()
	get_tree().quit()


func _on_Button_pressed():
	add_child(settingmenu.instance())


func _on_SoundControl_pressed():
	add_child(soundmenu.instance())
