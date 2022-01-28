extends Area2D

export (String) var item_id
export (NodePath) onready var sack_item = get_node(sack_item) as RigidBody2D
export (NodePath) onready var coll_item = get_node(coll_item) as CollisionShape2D

var item : Item
var action = "pickup"
var object_name = ""

func _ready():
		if not item:
			item = Global.get_items(item_id)
		
		object_name = item.item_name

func _physics_process(_delta):
	coll_item.global_position = sack_item.global_position
	if sack_item.rotation_degrees != 0:
		sack_item.rotation_degrees = 0

func interact():
	Global.emit_signal("item_picked", item, self)

func item_picked():
	queue_free()

func _on_floor_item_body_entered(body):
	if body.name == "Player":
		PlayerStats.MAX_SPEED /= 2
		PlayerStats.ACCELERATION /= 2


func _on_floor_item_body_exited(body):
	if body.name == "Player":
		PlayerStats.MAX_SPEED *= 2
		PlayerStats.ACCELERATION *= 2
