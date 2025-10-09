@tool
extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@export_range(0, 7) var direction: int = 0:
	get:
		return direction
	set(value):
		direction = value
		var triangles := PackedVector3Array([
			Vector3(0.5,-0.5,0.5),
			Vector3(-0.5,0.5,-0.5),
			Vector3(0.5,-0.5,-0.5),
			Vector3(-0.5,0.5,-0.5),
			Vector3(0.5,-0.5,0.5),
			Vector3(-0.5,0.5,0.5),
		])
		_gen_mesh(triangles)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotation += Vector3(0,PI * delta,0)
	pass
	
func _gen_mesh(triangles: PackedVector3Array) -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for t in triangles:
		st.add_vertex(t)
	mesh_instance_3d.mesh = st.commit()
