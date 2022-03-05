extends TextureRect

onready var TexturProgess = $TextureProgress

func _ready():
	TexturProgess.value = 100

func set_percent_value(value):
	TexturProgess.value = value

