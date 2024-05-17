class_name Enemy_Attack_Controller
extends Node

@onready var bullet_prefab = preload("res://src/Bullet.tscn")
@onready var shoot_timer = $Shoot
@onready var rotator = $"../Rotator"

@export var rotate_speed : float = 100
@export var shooter_timer_wait_time : float = 0.2
@export var fire_point_count : int = 4
@export var radius : float = 50
@export var bullet_speed : float = 5
@export var bullet_rotation : float = 0

var lock_rotation : bool = false
var counter : int = 0

func _ready():
	var step = 2 * PI / fire_point_count
	
	for i in range(fire_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)
	
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()

func _process(delta):
	if lock_rotation:
		return
	
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)

func shoot():
	for s in rotator.get_children():
		var new_bullet = bullet_prefab.instantiate()
		new_bullet.group_name = "Enemy"
		new_bullet.move_dir = s.global_rotation
		new_bullet.spawn_pos = s.global_position
		new_bullet.spawn_rot = s.global_rotation
		
		new_bullet.speed = bullet_speed
		new_bullet.rot_speed = bullet_rotation
		
		get_parent().get_parent().add_child(new_bullet)
	

func _on_shoot_timeout():
	shoot()
