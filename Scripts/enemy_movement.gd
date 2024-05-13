class_name Enemy_Movement
extends Node

enum states{STRAFING, MOVING}

@onready var move_timer = $"../Move Timer"

var moving_states = states.MOVING

@export var max_speed : float = 5
@export var accel : float = 0
var move_dir : Vector2

@export var strafe_move_time_max : float = 3
@export var strafe_move_time_min : float = 0.5

var pause : bool = false
@export var wall_rays : Array[RayCast2D]

var parent 

func _ready():
	parent = get_parent()

func _physics_process(delta):
	movement(delta)
	parent.move_and_collide(parent.velocity)

func set_move_dir(new_pos : Vector2):
	if moving_states == states.STRAFING:
		return
	
	var new_dir = new_pos - parent.position
	move_dir = new_dir.normalized()

func movement(delta):
	parent.velocity += move_dir * accel
	
	parent.velocity = parent.velocity.limit_length(max_speed)

func strafe():
	var dir_chosen = randi_range(0, wall_rays.size() - 1)
	move_dir = get_ray_dir(wall_rays[dir_chosen])

func check_rays():
	for r in wall_rays:
		if r.is_colliding():
			move_dir = -get_ray_dir(r)
			return

func get_ray_dir(ray):
	var r_global_origin = ray.to_global(Vector2.ZERO)
	var r_global_cast_to_endpoint = ray.get_child(0).global_position
	var r_global_cast_to_vector = r_global_cast_to_endpoint - r_global_origin
	return r_global_cast_to_vector

func _on_stop_range_area_entered(area):
	if moving_states == states.STRAFING:
		return
	
	moving_states = states.STRAFING
	pause = true
	strafe()
	move_timer.start()

func _on_ray_check_timeout():
	check_rays()

func _on_stop_range_area_exited(area):
	pause = false

func _on_move_timer_timeout():
	move_timer.wait_time = randf_range(strafe_move_time_min, strafe_move_time_max)
	strafe()

func _on_chase_range_area_exited(area):
	pause = false
	move_timer.stop()
	moving_states = states.MOVING
