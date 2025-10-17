class_name Player extends CharacterBody2D

@export var speed := 150.0
@export var ground_friction_factor := 20.0
@export var dash_cooldown := 1.0
@export var dash_multiplier := 10.0

# Zweiter Dash einbauen. Einfach Code kopieren und Dash für Dash abarbeiten.

@onready var dash_cooldown_timer := Timer.new()

func _ready() -> void:
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.autostart = false
	dash_cooldown_timer.wait_time = dash_cooldown
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)
	add_child(dash_cooldown_timer)

func _physics_process(delta: float) -> void:
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
		dash_cooldown_timer.start()
		velocity += move_direction * speed * dash_multiplier
	var desired_velocity := speed * move_direction
	var steering := desired_velocity - velocity
	velocity += steering * ground_friction_factor * delta
	move_and_slide()


func _on_dash_cooldown_timeout() -> void:
	print("Dash cooldown finished")
