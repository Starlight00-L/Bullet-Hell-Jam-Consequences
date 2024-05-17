class_name Player_Attack_Controller
extends Node

@onready var gun = $"../Gun"
@onready var fire_point = $"../Gun/Fire Point"
@onready var fire_timer = $Fire
@onready var bullet_prefab = preload("res://src/Bullet.tscn")

@export var bullet_damage : int = 1
@export var fire_rate : float = 1
@export var bullet_speed : float = 5

func _ready():
	fire_timer.wait_time = fire_rate

func _process(_delta):
	if Input.is_action_pressed("Fire") && fire_timer.time_left == 0:
		fire()
		fire_timer.start()
	
	if gun.position > gun.get_global_mouse_position():
		gun.get_child(0).flip_v = true
	else:
		gun.get_child(0).flip_v = false

func fire():
	var new_bullet = bullet_prefab.instantiate()
	new_bullet.group_name = "Player"
	new_bullet.damage = bullet_damage
	new_bullet.speed = bullet_speed
	new_bullet.move_dir = fire_point.get_parent().rotation
	new_bullet.spawn_pos = fire_point.global_position
	new_bullet.spawn_rot = fire_point.get_parent().rotation
	get_parent().get_parent().add_child(new_bullet)


func _on_fire_timeout():
	pass
