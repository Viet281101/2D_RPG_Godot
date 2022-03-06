extends TextureRect

var stats = PlayerStats
onready var TexturProgess = $FullBar

func _ready():
	TexturProgess.value = stats.experience_total
	TexturProgess.initialized(stats.experience, stats.experience_required)

func set_percent_value(value):
	TexturProgess.value = value

func _process(_delta):
	pass
