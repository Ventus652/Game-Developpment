extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animation(direction)
	move_and_slide()


func update_animation(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		if direction == 0:
			play_animation("idle")
		else:
			play_animation("run")
	else:
		play_animation("jump")


func play_animation(animation_name: StringName) -> void:
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)
	else:
		animated_sprite.play("idle")
