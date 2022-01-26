extends CanvasLayer

export(int) var bullet_nbr = 0
onready var flame_bullet = $FlameBullet
onready var flame_nbr = $FlameBullet/Number

func _ready():
	flame_nbr.text = String(bullet_nbr)

func _on_Scepter_p_up():
	flame_bullet.visible = true
	bullet_nbr += 1
	_ready()

func _on_Scepter_p_down():
	bullet_nbr -= 1
	if bullet_nbr <= 0:
		bullet_nbr = 0
	_ready()

func _exit_tree():
	self.queue_free()
