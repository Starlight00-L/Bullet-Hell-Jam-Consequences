class_name Wave_Manager
extends Node2D

@onready var enemy = preload("res://src/enemy.tscn")
@onready var spawn_delay_timer = $Spawn_Delay

@export var spawn_points : Array[Node2D]
@export var attack_pattern_difficulties : Array[Attack_Pattern]
var current_difficulty : Attack_Pattern
@export var num_of_enemies_per_wave : Array[int]
@export var total_num_of_waves : int = 30
var current_wave : int = -1
var wave_in_progress : bool = false
var total_enemies_in_wave : int = 0
@export var max_spawn_wait_time : float = 2

var enemy_parent

signal wave_end

func _ready():
	enemy_parent = get_parent()
	
	for w in range(total_num_of_waves):
		var enemy_num = randi_range(1, 5)
		num_of_enemies_per_wave.append(enemy_num)
	
	current_difficulty = attack_pattern_difficulties[0]

func _process(delta):
	if wave_in_progress && total_enemies_in_wave == 0:
		end_wave()
	

func start_wave():
	current_wave += 1
	print("Wave ", current_wave + 1, " started!")
	check_difficulty()
	spawn_delay_timer.wait_time = randf_range(0, max_spawn_wait_time)
	spawn_delay_timer.start()

func end_wave():
	emit_signal("wave_end")
	print("Wave ", current_wave + 1, " ended!")
	wave_in_progress = false

func check_difficulty():
	if (current_wave + 1) % attack_pattern_difficulties.size() == 0:
		var scale = (current_wave + 1) / attack_pattern_difficulties.size()
		current_difficulty = attack_pattern_difficulties[scale]

func enemy_killed():
	total_enemies_in_wave -= 1

func spawn_enemy():
	var new_enemy = enemy.instantiate()
	new_enemy.attack_pattern = current_difficulty
	var chosen_spawn = randi_range(0, spawn_points.size() - 1)
	new_enemy.position = spawn_points[chosen_spawn].global_position
	enemy_parent.add_child(new_enemy)
	total_enemies_in_wave += 1

func _on_spawn_delay_timeout():
	spawn_enemy()
	wave_in_progress = true
	
	if total_enemies_in_wave != num_of_enemies_per_wave[current_wave]:
		spawn_delay_timer.wait_time = randf_range(0, max_spawn_wait_time)
		spawn_delay_timer.start()

