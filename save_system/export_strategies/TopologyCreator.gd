extends Node

class_name TopologyCreator

var top_neigbours = {}
var bottom_neigbours = {}
var front_neigbours = {}
var back_neigbours = {}
var left_neigbours = {}
var right_neigbours = {}

func create_topology(voxels: Array) -> PoolVector3Array:
	var coordinates = PoolVector3Array()
	for raw_voxel in voxels:
		var voxel = raw_voxel as Voxel
		coordinates.append(voxel.translation)
	
	var topology = PoolVector3Array()
	
	for voxel in coordinates:
		var voxel_sides := []
		if not voxels.has(Vector3(voxel.x, voxel.y + 1, voxel.z)): voxel_sides += top
		if not voxels.has(Vector3(voxel.x, voxel.y - 1, voxel.z)): voxel_sides += bottom
		if not voxels.has(Vector3(voxel.x - 1, voxel.y, voxel.z)): voxel_sides += left
		if not voxels.has(Vector3(voxel.x + 1, voxel.y, voxel.z)): voxel_sides += right
		if not voxels.has(Vector3(voxel.x, voxel.y, voxel.z + 1)): voxel_sides += front
		if not voxels.has(Vector3(voxel.x, voxel.y, voxel.z - 1)): voxel_sides += back

		for side in voxel_sides:
			topology.append((side * 0.5) + side)

	return topology

var top = [
	Vector3( 1.0000, 1.0000, 1.0000),
	Vector3(-1.0000, 1.0000, 1.0000),
	Vector3(-1.0000, 1.0000,-1.0000),
	
	Vector3(-1.0000, 1.0000,-1.0000),
	Vector3( 1.0000, 1.0000,-1.0000),
	Vector3( 1.0000, 1.0000, 1.0000),
]

var bottom = [
	Vector3(-1.0000,-1.0000,-1.0000),
	Vector3(-1.0000,-1.0000, 1.0000),
	Vector3( 1.0000,-1.0000, 1.0000),
	
	Vector3( 1.0000, -1.0000, 1.0000),
	Vector3( 1.0000, -1.0000,-1.0000),
	Vector3(-1.0000, -1.0000,-1.0000),
]

var front = [
	Vector3(-1.0000, 1.0000, 1.0000),
	Vector3( 1.0000, 1.0000, 1.0000),
	Vector3( 1.0000,-1.0000, 1.0000),
	
	Vector3( 1.0000,-1.0000, 1.0000),
	Vector3(-1.0000,-1.0000, 1.0000),
	Vector3(-1.0000, 1.0000, 1.0000),
]

var back = [
	Vector3( 1.0000,-1.0000,-1.0000),
	Vector3( 1.0000, 1.0000,-1.0000),
	Vector3(-1.0000, 1.0000,-1.0000),
	
	Vector3(-1.0000, 1.0000,-1.0000),
	Vector3(-1.0000,-1.0000,-1.0000),
	Vector3( 1.0000,-1.0000,-1.0000)
]

var left = [
	Vector3(-1.0000, 1.0000, 1.0000),
	Vector3(-1.0000,-1.0000, 1.0000),
	Vector3(-1.0000,-1.0000,-1.0000),
	
	Vector3(-1.0000,-1.0000,-1.0000),
	Vector3(-1.0000, 1.0000,-1.0000),
	Vector3(-1.0000, 1.0000, 1.0000),
]

var right = [
	Vector3( 1.0000, 1.0000, 1.0000),
	Vector3( 1.0000, 1.0000,-1.0000),
	Vector3( 1.0000,-1.0000,-1.0000),
	
	Vector3( 1.0000,-1.0000,-1.0000),
	Vector3( 1.0000,-1.0000, 1.0000),
	Vector3( 1.0000, 1.0000, 1.0000),
]
