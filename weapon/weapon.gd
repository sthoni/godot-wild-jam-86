class_name Weapon extends Node2D

@export var damage = 10
@export var cooldown = 1.0

@onready var hit_area: Area2D = $Area2D
@onready var cooldown_timer: Timer = Timer.new()

func _ready() -> void:
	cooldown_timer.wait_time = cooldown
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func attack() -> void:
	if not cooldown_timer.is_stopped():
		return
	cooldown_timer.start()
	if hit_area.has_overlapping_areas():
		var areas := hit_area.get_overlapping_areas()
		for area in areas:
			if area.is_in_group("enemy_hitbox"):
				print("Hit enemy!")
				if area.get_parent() is Mob:
					area.get_parent().take_damage(damage)
