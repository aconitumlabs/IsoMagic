extends StaticBody3D

@export var node = preload("res://Scenes/cube.tscn")

func _ready() -> void:
	var child_instance = node.instantiate()
	
	var slot = $Slot
	
	slot.add_child(child_instance)
	
	$Label3D.text = child_instance.name
	
	child_instance.transform = Transform3D.IDENTITY
	
	child_instance.scale = Vector3(0.2, 0.2, 0.2)
