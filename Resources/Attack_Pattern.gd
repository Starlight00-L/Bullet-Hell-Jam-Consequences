class_name Attack_Pattern
extends Resource

@export var rotate_speed_range : Vector2 = Vector2(-100, 100)
@export var shooter_timer_wait_time_range : Vector2 = Vector2(0.1, 2)
@export var fire_point_count_range : Vector2 = Vector2(1, 10)
@export var bullet_speed_range : Vector2 = Vector2(-10, 10)
@export var bullet_rotation_range : Vector2 = Vector2(-5, 5)
@export var bullet_lifetime : float = 10

func get_rotate_speed():
	var new_rotate_speed = randf_range(rotate_speed_range.x, rotate_speed_range.y)
	if new_rotate_speed > -10 && new_rotate_speed < 10:
		new_rotate_speed = rotate_speed_range.y / 2
	return new_rotate_speed

func get_fire_rate():
	var new_fire_rate = randf_range(shooter_timer_wait_time_range.x, shooter_timer_wait_time_range.y)
	return new_fire_rate

func get_fire_points():
	var new_fire_point_amt = randf_range(fire_point_count_range.x, fire_point_count_range.y)
	return new_fire_point_amt

func get_bullet_speed():
	var new_bullet_speed = randf_range(bullet_speed_range.x, bullet_speed_range.y)
	if new_bullet_speed > -2 && new_bullet_speed < 2:
		new_bullet_speed = (abs(bullet_speed_range.x) + abs(bullet_speed_range.y)) / 2
	return new_bullet_speed

func get_bullet_rotation():
	var new_bullet_rotation = randf_range(bullet_rotation_range.x, bullet_rotation_range.y)
	return new_bullet_rotation
