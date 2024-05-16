class_name Player_Movement
extends Node

@export var max_speed = 120
@export var acceleration = 800
@export var friction = 500

enum {IDLE, RUN}
var state = IDLE

var parent
var input = Vector2.ZERO

func _ready():
	parent = get_parent()

func _physics_process(delta):
	movement(delta)

func movement(delta):
	input = Input.get_vector("Left", "Right", "Up", "Down")
	if input == Vector2.ZERO:
		state = IDLE
		apply_friction(friction * delta)
	else:
		state = RUN
		apply_movement(input * acceleration * delta)
	
	parent.move_and_slide()

func apply_friction(amount):
	if parent.velocity.length() > amount:
		parent.velocity -= parent.velocity.normalized() * amount
	else:
		parent.velocity = Vector2.ZERO

func apply_movement(amount):
	parent.velocity += amount
	parent.velocity = parent.velocity.limit_length(max_speed)
