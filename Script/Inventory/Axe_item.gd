extends Area2D

export (String) var item_id
export (NodePath) onready var Axe = get_node(Axe) as Sprite
export (NodePath) onready var seek_player = get_node(seek_player) as CollisionShape2D

var item : Item
var action = "pickup"
var object_name = ""
export (bool) var have_axe

func _ready():
		if not item:
			item = Global.get_items(item_id)
		
		object_name = item.item_name

func _process(_delta):
	if !have_axe:
		Axe.hide()
		seek_player.disabled = true

func interact():
	if have_axe:
		Global.emit_signal("item_picked", item, self)
		have_axe = false
	

func item_picked():
	Axe.hide()
