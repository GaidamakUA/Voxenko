tool
extends Spatial

signal camera_moved(new_position)
signal pointing_at(cursor_position, cursor_rotation)

export(int, 1, 100, 1) var ray_length = 10
export(float, 0, 20, 0.5) var distance: float = 5 setget _update_distance

onready var camera: Camera = $InnerGimbal/Camera

var invert_y = false
var invert_x = false
var mouse_sensitivity := 0.005
var zoom_sensitivity := 0.5

func _process(delta):
	if (Engine.editor_hint):
		return
	var mouse_position = get_viewport().get_mouse_position()
	var collistion_dict := raycast_from_mouse(mouse_position, 1)
	if collistion_dict.has_all(["position"]):
		var cursor_position: Vector3 = collistion_dict.position
		var cursor_normal = collistion_dict.normal
		if cursor_position:
			emit_signal("pointing_at", cursor_position, cursor_normal)

func _unhandled_input(event):
	if event is InputEventPanGesture:
		if event.delta.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.delta.x * mouse_sensitivity)
		if event.delta.y != 0:
			var dir = 1 if invert_y else -1
			$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * event.delta.y * mouse_sensitivity)
		emit_signal("camera_moved", $InnerGimbal/Camera.to_global(Vector3(0, 0, 0)))
	elif event is InputEventMagnifyGesture:
		var scale_delta: float = 1 / ((event.factor - 1) * zoom_sensitivity + 1)
		scale = scale * scale_delta

func _update_distance(new_distance: float):
	distance = new_distance
	scale = Vector3.ONE * new_distance

func raycast_from_mouse(mouse_position: Vector2, collision_mask) -> Dictionary:
	var ray_start := camera.project_ray_origin(mouse_position)
	var ray_end: Vector3 = ray_start + camera.project_ray_normal(mouse_position) * ray_length
	var space_state := get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
