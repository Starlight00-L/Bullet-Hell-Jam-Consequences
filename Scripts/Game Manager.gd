class_name Game_Manager
extends Node2D

@export var wave_manager : Wave_Manager
@export var bullet_manager : Bullet_Manager
@export var player : Player_Script
@onready var wave_detector = $"Wave Detector"
@onready var next_wave_timer = $"Next Wave"

func _ready():
	wave_manager.connect("wave_end", start_buffer)

func start_buffer():
	bullet_manager.destroy_bullets()
	next_wave_timer.start()

func _on_start_wave_detector_area_entered(area):
	if area.is_in_group("Player"):
		if !wave_manager.wave_in_progress:
			wave_manager.start_wave()
			wave_detector.position = Vector2(0, 1500)


func _on_next_wave_timeout():
	wave_detector.position = Vector2(0, 0)
