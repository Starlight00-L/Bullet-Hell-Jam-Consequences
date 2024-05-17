class_name Enemy_Movement
extends Node

enum states{STRAFING, MOVING}

@onready var move_timer = $"../Move Timer"
@onready var ray_check_timer = $"../Ray check"
@onready var avoid_timer = $"../Avoid duration"
@onready var direction_ray = $"../Direction Holder/Direction Ray"

var moving_states = states.MOVING

@export var max_speed : float = 5
@export var accel : float = 0
@export var rot_speed : float = 2
var angle_cone_of_vision := deg_to_rad(161)
var max_view_distance := 150
var angle_between_rays := deg_to_rad(40)
var move_dir : Vector2

@export var strafe_move_time_max : float = 3
@export var strafe_move_time_min : float = 0.5

var pause : bool = false
@export var wall_rays : Array[RayCast2D]

var parent 

func _ready():
	parent = get_parent()
	generate_raycasts()

func _physics_process(delta):
	check_movement_direction(delta)
	movement(delta)
	parent.move_and_collide(parent.velocity)

func set_move_dir(new_pos : Vector2):
	if moving_states == states.STRAFING:
		return
	
	var new_dir = new_pos - parent.position
	direction_ray.rotation = new_dir.angle()
	move_dir = new_dir.normalized()

func check_movement_direction(delta): #moves direction when detecting an obstacle in front of it
	for ray in direction_ray.get_children():
		if ray is RayCast2D && ray.is_colliding():
			moving_states = states.STRAFING
			if ray.rotation > 0:
				direction_ray.rotate(delta * -rot_speed)
			elif ray.rotation < 0:
				direction_ray.rotate(delta * rot_speed)
			avoid_timer.start()
			move_dir = get_ray_dir(direction_ray)
			break

func movement(delta):
	parent.velocity += move_dir * accel
	
	parent.velocity = parent.velocity.limit_length(max_speed)

func strafe():
	var dir_chosen = randi_range(0, wall_rays.size() - 1)
	move_dir = get_ray_dir(wall_rays[dir_chosen])
	direction_ray.rotate(move_dir.angle())

func check_rays():
	for r in wall_rays:
		if r.is_colliding():
			move_dir = -get_ray_dir(r)
			moving_states = states.STRAFING
			avoid_timer.start()
			return

func generate_raycasts(): #Makes raycasts onto direction ray in a cone for obstacle avoidence
	var ray_count := angle_cone_of_vision / angle_between_rays
	
	for index in ray_count:
		var ray := RayCast2D.new()
		var angle := angle_between_rays * (index - ray_count / 2.0)
		ray.rotation = angle
		ray.target_position.y = max_view_distance
		ray.set_collision_mask_value(1, false)
		ray.set_collision_mask_value(2, true)
		ray.collide_with_bodies = false
		ray.collide_with_areas = true
		direction_ray.add_child(ray)
		ray.enabled = true

func get_ray_dir(ray):
	var r_global_origin = ray.to_global(Vector2.ZERO)
	var r_global_cast_to_endpoint = ray.get_child(0).global_position
	var r_global_cast_to_vector = r_global_cast_to_endpoint - r_global_origin
	return r_global_cast_to_vector

func _on_stop_range_area_entered(area):
	if !area.is_in_group("Player"):
		return
	
	if moving_states == states.STRAFING:
		return
	
	moving_states = states.STRAFING
	pause = true
	strafe()
	ray_check_timer.start()
	move_timer.start()

func _on_move_timer_timeout():
	move_timer.wait_time = randf_range(strafe_move_time_min, strafe_move_time_max)
	strafe()

func _on_chase_range_area_exited(area):
	if area.is_in_group("Player"):
		pause = false
		ray_check_timer.stop()
		move_timer.stop()
		moving_states = states.MOVING

func _on_ray_check_timeout():
	check_rays()

func _on_avoid_duration_timeout():
	moving_states = states.MOVING
