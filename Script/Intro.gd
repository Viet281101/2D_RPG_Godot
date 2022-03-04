extends ColorRect

export (NodePath) onready var anim_intro = get_node(anim_intro) as AnimationPlayer

func _ready():
	Global.stop_music()
	Global.current_level = self.name
	if Global.get_start:
		anim_intro.play("start")
	elif Global.get_start == false:
		anim_intro.play("Intro")

func _start_finished():
	yield($AnimationPlayer, "animation_finished")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")
	Global.play_music()
	if Global.first_level:
		Effects.scene_changer.fade_out()

func _intro_finished():
	yield(get_tree().create_timer(3), "timeout")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scene/MainMenu.tscn")
	Global.play_music()
	if Global.first_level:
		Effects.scene_changer.fade_out()

func _exit_tree():
	self.queue_free()

func _on_Button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scene/MainMenu.tscn")
	Global.play_music()
	if Global.first_level:
		Effects.scene_changer.fade_out()
	
