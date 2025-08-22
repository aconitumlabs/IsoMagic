extends StaticBody3D

var click = false

func _ready() -> void:
	$Light.visible = false

func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	$Light.visible = true

func _on_mouse_exited() -> void:
	$Light.visible = false


func _input(event: InputEvent) -> void:
	pass
