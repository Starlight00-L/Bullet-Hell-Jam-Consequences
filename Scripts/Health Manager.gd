class_name Health_Manager
extends Node

@export var max_health : int = 5
var current_health : int = 5

func _ready():
	current_health = max_health

func take_damage(amount):
	print(get_parent().name, " has taken damage!")
	current_health -= amount
	
	if current_health <= 0:
		death()
	
	print("Health is now ", current_health)

func death():
	get_parent().queue_free()
