tool
extends Spatial

signal camera_moved(new_position)
signal pointing_at(position, normal)

export(int, 1, 100, 1) var ray_length = 10
export(float, 0, 20, 0.5) var distance: float = 5 setget _update_distance

onready var camera: Camera = $InnerGimbal/Camera
onready var grid := get_parent().find_node("Grid") as Grid

var invert_y = false
var invert_x = false
var mouse_sensitivity := 0.005
var zoom_sensitivity := 0.5

func _process(delta):
	if (Engine.editor_hint):
		return
	var mouse_position = get_viewport().get_mouse_position()
	var collistion_dict := raycast_from_mouse(mouse_position, 1)
	if collistion_dict.has("position"):
		var cursor_position: Vector3 = collistion_dict.position
		var cursor_normal: Vector3 = collistion_dict.normal
		if cursor_position:
			_emit_cursor_position(cursor_position, cursor_normal)

func _unhandled_input(event):
	if event is InputEventMouseMotion && Input.is_action_pressed("camera_movement"):
		_move_camera_by_delta(event.relative * -1)
		emit_signal("camera_moved", $InnerGimbal/Camera.to_global(Vector3(0, 0, 0)))
	if event is InputEventPanGesture:
		_move_camera_by_delta(event.delta)
		emit_signal("camera_moved", $InnerGimbal/Camera.to_global(Vector3(0, 0, 0)))
	elif event is InputEventMagnifyGesture:
		var scale_delta: float = 1 / ((event.factor - 1) * zoom_sensitivity + 1)
		scale = scale * scale_delta

func _move_camera_by_delta(delta: Vector2):
	if delta.x != 0:
		var dir = 1 if invert_x else -1
		rotate_object_local(Vector3.UP, dir * delta.x * mouse_sensitivity)
	if delta.y != 0:
		var dir = 1 if invert_y else -1
		$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * delta.y * mouse_sensitivity)

func _update_distance(new_distance: float):
	distance = new_distance
	scale = Vector3.ONE * new_distance

func raycast_from_mouse(mouse_position: Vector2, collision_mask) -> Dictionary:
	var ray_start := camera.project_ray_origin(mouse_position)
	var ray_end: Vector3 = ray_start + camera.project_ray_normal(mouse_position) * ray_length
	var space_state := get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)

func _emit_cursor_position(raw_position: Vector3, raw_normal: Vector3):
	var normal = raw_normal.snapped(Vector3.ONE)
	var position = _get_proper_position(raw_position, normal)
	
	emit_signal("pointing_at", position, normal)

func _get_proper_position(raw_position: Vector3, normal: Vector3) -> Vector3:
	var position = raw_position
	var displacement = _get_snap_displacement()
	position += displacement
	position = position.snapped(Vector3.ONE)
	position -= displacement
	return position - normal / 2

func _get_snap_displacement() -> Vector3:
	var displacement = Vector3()
	if grid.grid_width % 2 == 0:
		displacement.x = 0.5
	if grid.grid_height % 2 == 0:
		displacement.y = 0.5
	if grid.grid_depth % 2 == 0:
		displacement.z = 0.5
	return displacement 
