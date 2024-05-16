class_name Player_Animation_Controller
extends Node

@onready var anim = $"../AnimationPlayer"
@onready var sprite = $"../Player Sprite"

func flip_animation(flip : bool):
	sprite.flip_h = flip

func play_animation(anim_name : String):
	anim.play(anim_name)
