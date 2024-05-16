class_name Enemy_AI
extends CharacterBody2D

@onready var movement_controller = $"Enemy movement"
@onready var health_controller = $"Health Manager"
@export var player : Node2D#refference to the player

func _process(_delta):
	movement_controller.set_move_dir(player.position)
