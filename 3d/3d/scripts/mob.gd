extends CharacterBody3D

signal squashed

@export var min_speed := 6
@export var max_speed := 17

var movement_speed := 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func initialize(start_position: Vector3, player_position: Vector3) -> void:
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4.0, PI / 4.0))
	movement_speed = float(randi_range(min_speed, max_speed))
	velocity = Vector3.FORWARD * movement_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	if animation_player != null and animation_player.is_playing():
		animation_player.speed_scale = clamp(movement_speed / float(max_speed), 0.75, 1.8)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func squash() -> void:
	squashed.emit()
	queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
