extends TextureRect

export (NodePath) onready var TexturProgess = get_node(TexturProgess) as TextureProgress

func _ready():
	TexturProgess.value = 100

func set_percent_value(value):
	TexturProgess.value = value

