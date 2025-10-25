extends Control

@onready var credits = $CanvasLayer/Credits

func _ready() -> void:
	credits.visible = false
	
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/LevelSelect/level_select.tscn")


func _on_credits_pressed() -> void:
	credits.visible = true
	if credits.has_method("play_intro_animation"):
		credits.play_intro_animation()

func _on_exit_pressed() -> void:
	get_tree().quit()
