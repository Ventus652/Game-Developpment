extends Node2D

enum WeatherState {
	SUNNY,
	CLOUDY,
	RAINY,
	STORMY
}

var current_state = WeatherState.SUNNY
var timer = 0.0

@onready var sprite = $Sprite2D

var sunny_texture = preload("res://img/Sunny.png")
var cloudy_texture = preload("res://img/Cloudy.png")
var rainy_texture = preload("res://img/Rainy.png")
var stormy_texture = preload("res://img/Stormy.png")


func _ready():
	sprite.texture = sunny_texture
	fit_sprite_to_screen()


func _process(delta):
	timer += delta

	if timer >= 3.0:
		timer = 0.0
		next_weather()


func next_weather():
	if current_state == WeatherState.SUNNY:
		current_state = WeatherState.CLOUDY
		sprite.texture = cloudy_texture

	elif current_state == WeatherState.CLOUDY:
		current_state = WeatherState.RAINY
		sprite.texture = rainy_texture

	elif current_state == WeatherState.RAINY:
		current_state = WeatherState.STORMY
		sprite.texture = stormy_texture

	elif current_state == WeatherState.STORMY:
		current_state = WeatherState.SUNNY
		sprite.texture = sunny_texture

	fit_sprite_to_screen()


func fit_sprite_to_screen():
	var screen_size = get_viewport_rect().size
	var image_size = sprite.texture.get_size()

	sprite.position = screen_size / 2
	sprite.scale = screen_size / image_size
