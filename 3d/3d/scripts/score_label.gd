extends Label

var score := 0

func reset() -> void:
	score = 0
	text = "Score: 0"

func _on_mob_squashed() -> void:
	score += 1
	text = "Score: %s" % score
