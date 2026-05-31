extends Area2D

@onready var timer: Timer = $Timer

var is_dying := false


func _on_body_entered(body: Node2D) -> void:
	if is_dying:
		return

	is_dying = true
	print("you died!")
	play_death_fall(body)
	timer.start()


func play_death_fall(body: Node2D) -> void:
	body.set_physics_process(false)

	if body is CharacterBody2D:
		body.velocity = Vector2.ZERO

	var collision_shape := body.get_node_or_null("CollisionShape2D")
	if collision_shape:
		collision_shape.set_deferred("disabled", true)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(body, "position:y", body.position.y + 80.0, 0.55)
	tween.tween_property(body, "modulate:a", 0.35, 0.55)


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
