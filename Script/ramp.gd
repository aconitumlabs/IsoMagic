@tool
extends Node3D

const initial_mesh :PackedVector3Array = [
	# front slope
	Vector3(0.5,-0.5,0.5),
	Vector3(-0.5,0.5,-0.5),
	Vector3(0.5,-0.5,-0.5),

	Vector3(-0.5,0.5,-0.5),
	Vector3(0.5,-0.5,0.5),
	Vector3(-0.5,0.5,0.5),

	# right side
	Vector3(0.5,-0.5,-0.5),
	Vector3(-0.5,0.5,-0.5),
	Vector3(-0.5,-0.5,-0.5),

	# back side
	Vector3(-0.5,-0.5,-0.5),
	Vector3(-0.5,0.5,0.5),
	Vector3(-0.5,-0.5,0.5),
	
	Vector3(-0.5,-0.5,-0.5),
	Vector3(-0.5,0.5,-0.5),
	Vector3(-0.5,0.5,0.5),

	# left side
	Vector3(-0.5,-0.5,0.5),
	Vector3(-0.5,0.5,0.5),
	Vector3(0.5,-0.5,0.5),

	# bottom
	Vector3(0.5,-0.5,0.5),
	Vector3(0.5,-0.5,-0.5),
	Vector3(-0.5,-0.5,-0.5),

	Vector3(0.5,-0.5,0.5),
	Vector3(-0.5,-0.5,-0.5),
	Vector3(-0.5,-0.5,0.5),
]

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@export_range(0, 7) var direction: int = 0:
	get:
		return direction
	set(value):
		if mesh_instance_3d == null: 
			return
		direction = value
		_gen_mesh(initial_mesh)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_gen_mesh(initial_mesh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#rotation += Vector3(0,PI * delta,0)
	pass
	
func _gen_mesh(triangles: PackedVector3Array) -> void:
	var st := SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_color(Color.BLUE)
	for t in triangles:
		st.set_smooth_group(-1)
		st.add_vertex(t)
	st.generate_normals()
	st.index()
	mesh_instance_3d.mesh = st.commit()
