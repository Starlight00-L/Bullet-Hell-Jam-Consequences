class_name Player_Script
extends CharacterBody2D

@onready var movement_controller = $"Player Movement"
@onready var anim_controller = $"Animation Controller"

func _process(delta):
	if movement_controller.state == movement_controller.IDLE:
		anim_controller.play_animation("Idle")
	else:
		anim_controller.play_animation("Run")
	
	if movement_controller.input.x < 0:
		anim_controller.flip_animation(true)
	elif movement_controller.input.x > 0:
		anim_controller.flip_animation(false)
	
