extends Sprite


func _ready():
	pass


func _physics_process(_delta):
	if global_rotation != 0:
		global_rotation = 0
