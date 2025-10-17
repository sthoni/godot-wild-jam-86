class_name Mob extends CharacterBody2D

@export var speed := 50.0
@export var health := 50

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("players")
	if player:
		var direction = player.position - position
		direction = direction.normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
