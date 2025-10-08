extends Node2D

@onready var camera: Camera2D = $Level_Select_Camera

@export var move_increment: float = 448.0
@export var move_duration: float = 0.4

const MIN_X: float = 600.0
const MAX_X: float = 2304.0

var camera_tween: Tween

func _ready():
	camera.position.x = MIN_X
	
	var button_instance = $Button
	button_instance.grab_focus()

func _on_left_button_pressed() -> void:
	var target_x = camera.position.x - move_increment
	target_x = max(target_x, MIN_X)
	_move_camera(target_x)

func _on_right_button_pressed() -> void:
	var target_x = camera.position.x + move_increment
	target_x = min(target_x, MAX_X)
	_move_camera(target_x)

func _move_camera(target_x: float):
	if camera_tween and camera_tween.is_running():
		camera_tween.kill()

	camera_tween = create_tween()
	camera_tween.tween_property(camera, "position:x", target_x, move_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
