tool
extends MeshInstance

export(int, 1, 50) var grid_width := 5 setget _width_updated
export(int, 1, 50) var grid_height := 5 setget _height_updated

func _ready():
	_regenerate_mesh()

func _width_updated(width):
	grid_width = width
	_regenerate_mesh()

func _height_updated(height):
	grid_height = height
	_regenerate_mesh()
	
func _regenerate_mesh():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_LINES)
	var starting_point = Vector3(-grid_width / 2.0, -grid_height / 2.0, 0)
	for i in range(grid_width + 1):
		var start = starting_point + Vector3.RIGHT * i
		surface_tool.add_vertex(start)
		var finish = start + Vector3.UP * grid_height
		surface_tool.add_vertex(finish)
	for i in range(grid_height + 1):
		var start = starting_point + Vector3.UP * i
		surface_tool.add_vertex(start)
		var finish = start + Vector3.RIGHT * grid_width
		surface_tool.add_vertex(finish)
	mesh = surface_tool.commit()
	
	$StaticBody/CollisionPolygon.scale = Vector3(grid_width, grid_height, 1)
