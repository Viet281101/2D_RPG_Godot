extends Control


func _ready():
	pass

func _process(_delta):
	if Global.music_on == true:
		$MusicOn.visible = false
		$MusicOff.visible = true
	elif Global.music_on == false:
		$MusicOn.visible = true
		$MusicOff.visible = false

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_Save_pressed():
	queue_free()



func _on_MusicOn_pressed():
	Global.play_music()
	Global.music_on = true


func _on_MusicOff_pressed():
	Global.stop_music()
	Global.music_on = false
