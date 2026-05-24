extends CanvasLayer

signal start_game

@onready var score_label = $ScoreLabel
@onready var highscore_label = $HighscoreLabel
@onready var message = $Message
@onready var start_button = $StartButton
@onready var message_timer = $MessageTimer

func _unhandled_input(event):
	if start_button.visible and event.is_action_pressed("start_game"):
		_on_start_button_pressed()

func show_message(text):
	message.text = text
	message.show()
	message_timer.start()

func show_game_over(score, highscore):
	show_message("Game Over")
	await message_timer.timeout
	message.text = "Dodge the Creeps!"
	message.show()
	start_button.show()
	update_score(score)
	update_highscore(highscore)

func update_score(score):
	score_label.text = str(score)

func update_highscore(highscore):
	highscore_label.text = "Best: " + str(highscore)

func _on_start_button_pressed():
	start_button.hide()
	start_game.emit()

func _on_message_timer_timeout():
	message.hide()
