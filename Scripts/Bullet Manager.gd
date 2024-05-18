class_name Bullet_Manager
extends Node2D

var bullets_in_play : Array[Bullet]

func add_bullet(new_bullet : Bullet):
	bullets_in_play.append(new_bullet)

func destroy_bullets():
	for b in bullets_in_play:
		if b != null:
			b.queue_free()
	
	bullets_in_play.clear()
