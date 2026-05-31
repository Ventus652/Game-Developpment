extends Node

@export var mob_scene: PackedScene

var game_over := false

@onready var player: CharacterBody3D = $Player
@onready var mob_timer: Timer = $MobTimer
@onready var spawn_location: PathFollow3D = $SpawnPath/SpawnLocation
@onready var score_label := $UserInterface/ScoreLabel
@onready var retry_panel: ColorRect = $UserInterface/Retry
@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	randomize()
	retry_panel.hide()
	score_label.call("reset")
	player.hit.connect(_on_player_hit)
	mob_timer.timeout.connect(_on_mob_timer_timeout)
	mob_timer.start()
	if music.stream != null:
		music.play()

func _unhandled_input(event: InputEvent) -> void:
	if game_over and (event.is_action_pressed("ui_accept") or event.is_action_pressed("restart")):
		get_tree().reload_current_scene()

func _on_mob_timer_timeout() -> void:
	if game_over or not is_instance_valid(player):
		return
	var mob := mob_scene.instantiate()
	spawn_location.progress_ratio = randf()
	add_child(mob)
	mob.squashed.connect(Callable(score_label, "_on_mob_squashed"))
	mob.initialize(spawn_location.global_position, player.global_position)

func _on_player_hit() -> void:
	game_over = true
	mob_timer.stop()
	retry_panel.show()
