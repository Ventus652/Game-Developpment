extends RigidBody2D

func _ready():
	add_to_group("mobs")
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var mob_type = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.play(mob_type)
	$AnimatedSprite2D.speed_scale = randf_range(0.8, 1.4)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
