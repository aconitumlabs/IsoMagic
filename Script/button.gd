extends Button

@export var next_scene: PackedScene

func _on_pressed() -> void:
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
	else :
		push_warning("Next Scene need to be defined in inspector")
