@tool
extends MeshInstance3D

@export_tool_button("Build mesh", "BoxMesh") var build_mesh = gen_mesh

@export_group("Colors")
@export var positive_x_color := Color(1, 0.25, 0.25) #FF4040
@export var negative_x_color := Color(1.0, 0.23,1.0 ) #FF3AFF
@export var positive_y_color := Color(0.24, 0.25, 1.0) #3C40FF
@export var negative_y_color := Color(0.21, 1.0, 1.0 ) #36FFFF
@export var positive_z_color := Color(1.0, 1.0, 0.26) #FFFF42
@export var negative_z_color := Color(1.0, 0.78, 0.26) #FFC642

const triangles :PackedVector3Array = [
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gen_mesh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#rotation += Vector3(-PI * delta,PI * delta,PI * delta)
	#print(Quaternion(basis))
	pass

func gen_mesh() -> void:
	assert(
		len(triangles) % 3 == 0,
		"ERROR: Mesh needs to specified in an array of triangles (3 vertices for each face)"
	)

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)


	var plane :PackedVector3Array = []
	var count := 0

	for t in triangles:
		plane.append(t)
		count += 1
		if count == 3:
			# uso get e nao [] para nao crashar o @tool caso eu faça merda
			var a := plane.get(0)
			var b := plane.get(1)
			var c := plane.get(2)
			var normal := Plane(a,b,c).normal

			for v in [a,b,c]:
				st.set_normal(normal)
				var color := Color()
				var transformed_normal := basis * normal
				var x := transformed_normal.x**2
				var y := transformed_normal.y**2
				var z := transformed_normal.z**2
				color += x * positive_x_color if transformed_normal.x >= 0 \
					else x * negative_x_color
				color += y * positive_y_color if transformed_normal.y >= 0 \
					else y * negative_y_color
				color += z * positive_z_color if transformed_normal.z >= 0 \
					else z * negative_z_color
				st.set_smooth_group(-1)
				st.set_color(color)
				st.add_vertex(v)
			count = 0
			plane.clear()
	st.index()
	mesh = st.commit()
