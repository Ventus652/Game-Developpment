extends Node

@export var mob_scene: PackedScene

var score = 0
var highscore = 0
var mob_min_speed = 150.0
var mob_max_speed = 250.0
var mob_wait_time = 0.5
var playing = false

func _ready():
	randomize()
	if not $Player.hit.is_connected(_on_player_hit):
		$Player.hit.connect(_on_player_hit)
	$HUD.update_score(score)
	$HUD.update_highscore(highscore)

func new_game():
	playing = true
	score = 0
	mob_min_speed = 150.0
	mob_max_speed = 250.0
	mob_wait_time = 0.5
	$MobTimer.wait_time = mob_wait_time
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$HUD.update_score(score)
	$HUD.update_highscore(highscore)
	$HUD.show_message("Get Ready")
	$StartTimer.start()
	$Music.play()

func game_over():
	if not playing:
		return

	playing = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()

	if score > highscore:
		highscore = score

	$HUD.show_game_over(score, highscore)

func _on_start_timer_timeout():
	if playing:
		$MobTimer.start()
		$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	mob_min_speed += 4.0
	mob_max_speed += 4.0
	mob_wait_time = max(0.18, mob_wait_time - 0.015)
	$MobTimer.wait_time = mob_wait_time

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(mob_min_speed, mob_max_speed), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)

func _on_player_hit():
	game_over()
