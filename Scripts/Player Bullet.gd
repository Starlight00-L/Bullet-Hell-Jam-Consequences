class_name Player_Bullet
extends CharacterBody2D

@onready var lifetime_timer = $Lifetime

@export var lifetime : float = 5
@export var speed : float = 5
@export var rot_speed : float = 0

var move_dir : float
var spawn_pos : Vector2
var spawn_rot : float

func _ready():
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	global_position = spawn_pos
	global_rotation = spawn_rot

func _physics_process(delta):
	velocity = Vector2(speed * 100, 0).rotated(move_dir)
	angular_movement(delta)
	move_and_slide()

func angular_movement(delta):
	move_dir += rot_speed * delta


func _on_lifetime_timeout():
	queue_free()
