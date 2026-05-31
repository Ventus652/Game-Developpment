extends Node

var cursor_texture = preload("res://assets/sprites/cursor.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, Vector2(8, 8))
