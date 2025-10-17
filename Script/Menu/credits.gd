extends ColorRect

func play_intro_animation() -> void:
	if not material:
		push_error("Este ColorRect (Credits) não tem um ShaderMaterial aplicado!")
		return

	(material as ShaderMaterial).set_shader_parameter("progress", 0.0)
	
	show()

	var tween := create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.1, 0.6)

func _on_back_button_pressed() -> void:
	if not material:
		return

	var tween := create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 0.6)
	
	tween.finished.connect(hide)
