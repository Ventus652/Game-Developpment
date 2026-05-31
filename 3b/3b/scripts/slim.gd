extends Node2D

const SPEED := 40.0
const WALL_CHECK_DISTANCE := 12.0
const WALL_MASK := 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction := 1


func _process(delta: float) -> void:
	if is_wall_ahead():
		direction *= -1

	animated_sprite.flip_h = direction < 0
	position.x += direction * SPEED * delta


func is_wall_ahead() -> bool:
	var space_state := get_world_2d().direct_space_state

	var from := global_position + Vector2(0, -8)
	var to := from + Vector2(direction * WALL_CHECK_DISTANCE, 0)

	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = WALL_MASK
	query.collide_with_bodies = true
	query.collide_with_areas = false

	return not space_state.intersect_ray(query).is_empty()
