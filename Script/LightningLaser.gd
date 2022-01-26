extends RayCast2D

export (NodePath) onready var line = get_node(line) as Line2D
export (NodePath) onready var col_line = get_node(col_line) as CollisionShape2D
export (NodePath) onready var light_line = get_node(light_line) as Light2D
export (NodePath) onready var end = get_node(end) as Node2D

var max_distance = 1000

func _ready():
	cast_to = Vector2(max_distance, 0)

func _physics_process(_delta):
	if is_colliding():
		var coll_point = to_local(get_collision_point())
		line.points[1].x = coll_point.x
		end.position.x = coll_point.x - 105
		col_line.position.x = coll_point.x - 45
		light_line.position.x = coll_point.x - 40
		
#		var shape = RectangleShape2D.new()
#		var half_way_amount = (global_position - coll_point)/2.0
#		shape.extents.x = half_way_amount.rotated(rotation).x
#		shape.extents.x = (coll_point.x - global_position.x)/2.0
#		col_line.shape = shape
