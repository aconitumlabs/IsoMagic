extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var grid: GridMap = $GridMap

# ===== initial orbital camera configuration =====
var target := Vector3.ZERO
var distance := 10.0
var desired_distance := 10.0
var sensitivity := 0.01
var zoom_speed := 2.0
var min_distance := 2.0
var max_distance := 50.0
var min_pitch := -80.0
var max_pitch := 80.0

# camera state
var rotating := false
var yaw := 0.0
var pitch := -20.0

# ===== highlight =====
var hovered_cell: Vector3i
var highlight_mesh: MeshInstance3D
var highlight_scale: Vector3

func _ready():
	# ---- creates wireframe highlight ----
	highlight_scale = grid.cell_size * 1.05
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)

	var s = highlight_scale / 2.0
	var corners = [
		Vector3(-s.x, -s.y, -s.z),
		Vector3(s.x, -s.y, -s.z),
		Vector3(s.x, s.y, -s.z),
		Vector3(-s.x, s.y, -s.z),
		Vector3(-s.x, -s.y, s.z),
		Vector3(s.x, -s.y, s.z),
		Vector3(s.x, s.y, s.z),
		Vector3(-s.x, s.y, s.z)
	]

	var lines = [
		[0,1],[1,2],[2,3],[3,0],  # bottom
		[4,5],[5,6],[6,7],[7,4],  # top
		[0,4],[1,5],[2,6],[3,7]   # sides
	]

	for l in lines:
		st.add_vertex(corners[l[0]])
		st.add_vertex(corners[l[1]])

	var mesh = st.commit()

	highlight_mesh = MeshInstance3D.new()
	highlight_mesh.mesh = mesh

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.WHITE
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS
	highlight_mesh.material_override = mat

	add_child(highlight_mesh)
	highlight_mesh.visible = false

	# ---- adjusts camera focus to center of grid ----
	_update_target_from_grid()

	# ---- initial camera configuration ----
	_update_camera_transform()

func _process(delta: float) -> void:
	# ---- updates highlight ----
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000.0

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	if result and result.collider == grid:
		var local_pos = grid.to_local(result.position)
		var cell = grid.local_to_map(local_pos)

		if grid.get_cell_item(cell) != -1:
			hovered_cell = cell
			highlight_mesh.visible = true
			highlight_mesh.global_transform.origin = grid.map_to_local(cell)
		else:
			highlight_mesh.visible = false
	else:
		highlight_mesh.visible = false

	# ---- smooth zoom ----
	distance = lerp(distance, desired_distance, delta * 8.0)
	_update_camera_transform()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			rotating = event.pressed   # left mouse button controls camera

		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if highlight_mesh.visible: # right mouse button deletes a cube
				grid.set_cell_item(hovered_cell, -1)
				highlight_mesh.visible = false
				_update_target_from_grid() # recalculates camera focus to grid center

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			desired_distance = max(min_distance, desired_distance - zoom_speed)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			desired_distance = min(max_distance, desired_distance + zoom_speed)

	elif event is InputEventMouseMotion and rotating:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

	elif event is InputEventPanGesture: # trackpad support
		desired_distance = clamp(desired_distance + event.delta.y * 0.05, min_distance, max_distance)

func _update_camera_transform():
	var dir = Vector3(
		cos(pitch) * sin(yaw),
		sin(pitch),
		cos(pitch) * cos(yaw)
	)
	camera.global_position = target - dir * distance
	camera.look_at(target, Vector3.UP)

func _update_target_from_grid():
	var used = grid.get_used_cells()
	if used.is_empty():
		target = Vector3.ZERO
		return

	var center := Vector3.ZERO
	for c in used:
		center += grid.map_to_local(c)
	target = center / float(used.size())
