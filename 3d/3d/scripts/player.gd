extends CharacterBody3D

signal hit
signal stomped

@export var speed := 14.0
@export var fall_acceleration := 75.0
@export var jump_impulse := 20.0
@export var bounce_impulse := 16.0
@export var max_air_jumps := 1
@export var stomp_horizontal_reach := 1.8
@export var stomp_vertical_reach := 2.25

var target_velocity := Vector3.ZERO
var air_jumps_left := 1
var alive := true

@onready var pivot: Node3D = $Pivot
@onready var mob_detector: Area3D = $MobDetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var stomp_sound: AudioStreamPlayer = $StompSound

func _ready() -> void:
	air_jumps_left = max_air_jumps
	if not mob_detector.body_entered.is_connected(_on_mob_detector_body_entered):
		mob_detector.body_entered.connect(_on_mob_detector_body_entered)

func _physics_process(delta: float) -> void:
	if not alive:
		return

	var direction := Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1.0
	if Input.is_action_pressed("move_left"):
		direction.x -= 1.0
	if Input.is_action_pressed("move_back"):
		direction.z += 1.0
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1.0

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.basis = Basis.looking_at(direction)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if is_on_floor():
		air_jumps_left = max_air_jumps
		if target_velocity.y < 0.0:
			target_velocity.y = 0.0

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			target_velocity.y = jump_impulse
			jump_sound.play()
		elif air_jumps_left > 0:
			air_jumps_left -= 1
			target_velocity.y = jump_impulse
			jump_sound.play()

	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta

	velocity = target_velocity
	move_and_slide()
	target_velocity.y = velocity.y
	_check_stomp_collisions()
	_check_mob_detector_overlaps()
	_check_nearby_air_stomps()
	_update_animation_speed()

func _check_stomp_collisions() -> void:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var collider := collision.get_collider()
		if collider == null:
			continue
		if collider.is_in_group("mob") and _can_stomp_mob():
			_stomp_mob(collider)

func _check_mob_detector_overlaps() -> void:
	for body in mob_detector.get_overlapping_bodies():
		if body == null or not body.is_in_group("mob") or body.is_queued_for_deletion():
			continue
		if _can_stomp_mob():
			_stomp_mob(body)
		else:
			die()
		return

func _check_nearby_air_stomps() -> void:
	if not _can_stomp_mob():
		return
	for node in get_tree().get_nodes_in_group("mob"):
		var mob := node as Node3D
		if mob == null or mob.is_queued_for_deletion():
			continue
		var offset := global_position - mob.global_position
		var horizontal_distance := Vector2(offset.x, offset.z).length()
		var inside_mob_height := offset.y >= -0.2 and offset.y <= stomp_vertical_reach
		if horizontal_distance <= stomp_horizontal_reach and inside_mob_height:
			_stomp_mob(mob)
			return

func _update_animation_speed() -> void:
	var ground_speed := Vector2(velocity.x, velocity.z).length()
	if animation_player.is_playing():
		animation_player.speed_scale = clamp(ground_speed / speed, 0.65, 1.8)

func die() -> void:
	if not alive:
		return
	alive = false
	hit.emit()
	queue_free()

func _can_stomp_mob() -> bool:
	return alive and (not is_on_floor() or target_velocity.y > 0.0 or velocity.y > 0.0)

func _stomp_mob(mob: Node3D) -> void:
	if not mob.has_method("squash"):
		return
	mob.squash()
	stomp_sound.play()
	stomped.emit()
	target_velocity.y = bounce_impulse
	velocity.y = bounce_impulse
	air_jumps_left = max_air_jumps

func _on_mob_detector_body_entered(body: Node3D) -> void:
	if body != null and body.is_in_group("mob"):
		if _can_stomp_mob():
			_stomp_mob(body)
			return
		die()
