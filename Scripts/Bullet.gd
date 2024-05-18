class_name Bullet
extends CharacterBody2D

@onready var lifetime_timer = $Lifetime
@onready var bullet_sprite = $"Bullet Sprite"

@export var group_name : String
@export var lifetime : float = 3
@export var damage : int = 1
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

func _process(delta):
	bullet_sprite.look_at(bullet_sprite.global_transform.origin + velocity)

func _physics_process(delta):
	velocity = Vector2(speed * 100, 0).rotated(move_dir)
	angular_movement(delta)
	move_and_slide()

func angular_movement(delta):
	move_dir += rot_speed * delta

func _on_lifetime_timeout():
	queue_free()

func _on_bullet_area_detection_area_entered(area):
	if !area.is_in_group(group_name):
		var obj_children = area.get_parent().get_children()
		for c in obj_children:
			if c.has_method("take_damage"):
				c.take_damage(damage)
				queue_free()
