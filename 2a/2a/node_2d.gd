extends Node2D

@onready var area_1 = $Area2D
@onready var area_2 = $Area2D2
@onready var area_3 = $Area2D3

func _process(delta):
	for child in get_children():
		child.rotation += 1.0 * delta

func _input(_event):
	if Input.is_action_just_pressed("change_area_1"): # A for red
		area_1.modulate = Color.RED

	if Input.is_action_just_pressed("change_area_2"):# S for grean
		area_2.modulate = Color.GREEN

	if Input.is_action_just_pressed("change_area_3"):# D for blue
		area_3.modulate = Color.BLUE
