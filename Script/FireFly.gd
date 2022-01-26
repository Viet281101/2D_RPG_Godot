extends KinematicBody2D

export var ACCELERATION = 100
export var MAX_SPEED = 40

var velocity = Vector2.ZERO
var life_time = rand_range(25,45)

export (NodePath) onready var wanderController = get_node(wanderController) as Node2D

func _ready():
	randomize()
	scale = Vector2(0.1, 0.1)
	$LifeTime.start(life_time)

func _physics_process(delta):
	var direction = global_position.direction_to(wanderController.target_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func start_timer_wander():
	wanderController.start_timer_wander(1)


func _on_LifeTime_timeout():
	queue_free()

func _exit_tree():
	self.queue_free()
