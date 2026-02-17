class_name Mob extends CharacterBody2D

@export var speed := 50.0
@export var health := 50
@export var avoidance_strength := 2000.0

@onready var _raycasts: Node2D = %Raycasts
@onready var weapon: Weapon = %Weapon

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("players")
	if player:
		attack(player)
		var direction = player.position - position
		direction = direction.normalized()
		velocity = direction * speed
		_raycasts.rotation = direction.angle() - PI / 2
		velocity += calculate_avoidance_force()
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func take_damage(damage: int):
	health -= damage
	print("Mob took damage")
	if health <= 0:
		queue_free()

## Returns a vector that represents the direction to avoid obstacles
func calculate_avoidance_force() -> Vector2:
	var avoidance_force := Vector2.ZERO

	for raycast: RayCast2D in _raycasts.get_children():
		if raycast.is_colliding():
			var collision_position := raycast.get_collision_point()
			var direction_away_from_obstacle := collision_position.direction_to(raycast.global_position)

			# The more the raycast is into the obstacle, the more we want to push away from the obstacle.
			var ray_length := raycast.target_position.length()
			var intensity := 1.0 - collision_position.distance_to(raycast.global_position) / ray_length

			var force := direction_away_from_obstacle * avoidance_strength * intensity
			avoidance_force += force

	return avoidance_force

func attack(player: Player) -> void:
	if player:
		weapon.rotation = player.position.direction_to(global_position).angle() + PI
