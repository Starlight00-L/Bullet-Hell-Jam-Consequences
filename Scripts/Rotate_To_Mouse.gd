class_name Rotate_To_Mouse_Script
extends Node2D

func _process(_delta):
	look_at(get_global_mouse_position())
