class_name Enemy_AI
extends CharacterBody2D

@onready var movement_controller = $"Enemy movement"
@onready var health_controller = $"Health Manager"
@onready var attack_controller = $"Enemy attack"

@export var attack_pattern : Attack_Pattern

var player : Node2D

func _ready():
	player = get_parent().get_node("Player")
	attack_controller.attack_pattern_stats = attack_pattern
	attack_controller.randomize_stats()
	attack_controller.set_up_attack()
	health_controller.connect("death_signal", on_death)

func _process(_delta):
	if player != null:
		movement_controller.set_move_dir(player.position)

func on_death():
	get_parent().get_node("Wave Manager").enemy_killed()
	queue_free()

func _on_attack_range_area_entered(area):
	if area.is_in_group("Player"):
		attack_controller.shoot_timer.start()


func _on_attack_range_area_exited(area):
	if area.is_in_group("Player"):
		attack_controller.shoot_timer.stop()
