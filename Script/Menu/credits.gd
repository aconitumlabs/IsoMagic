extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_intro_animation() -> void:
	animation_player.play("appear")
	#if not material:
		#push_error("Este ColorRect (Credits) não tem um ShaderMaterial aplicado!")
		#return
#
	#(material as ShaderMaterial).set_shader_parameter("progress", 0.0)
	#
	#show()
#
	#var tween := create_tween()
	#tween.tween_property(material, "shader_parameter/progress", 1.1, 0.6)

func _on_back_button_pressed() -> void:
	animation_player.play("disappear")
	#if not material:
		#return
#
	#var tween := create_tween()
	#tween.tween_property(material, "shader_parameter/progress", 0.0, 0.6)
	
	#tween.finished.connect(hide)
