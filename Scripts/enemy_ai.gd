class_name Enemy_AI
extends CharacterBody2D

@onready var movement_controller = $"Enemy movement"
@onready var health_controller = $"Health Manager"
@onready var attack_controller = $"Enemy attack"
@export var player : Node2D#refference to the player

func _ready():
	player = get_parent().get_node("Player")

func _process(_delta):
	if player != null:
		movement_controller.set_move_dir(player.position)
