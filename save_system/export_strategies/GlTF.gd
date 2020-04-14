extends ExportStrategy

onready var topology_creator: TopologyCreator = $TopologyCreator

func get_file_type() -> String:
	return ".gltf"
	
func get_description() -> String:
	return "GL Transmission Format"
	
func save_file(file_name: String, voxels: Array):
	var save_data := {}
	save_data.scenes = [{"nodes":[0]}]
	save_data.nodes = [{"mesh":0}]
	save_data.asset = {"version":"2.0"}
	save_data.meshes = [{"primitives":[{"attributes":{"POSITION":0}, "mode": 4 }]}]
	_create_data(voxels, save_data)
	
	var save_game = File.new()
	save_game.open(file_name, File.WRITE)
	save_game.store_string(to_json(save_data))
	save_game.close()

func _create_data(voxels: Array, save_data: Dictionary):
	var topology := topology_creator.create_topology(voxels)
	
	var buffer := _create_buffer(topology)
	save_data.buffers = [buffer]
	
	var buffer_view := {"buffer" : 0, "byteOffset" : 0, "byteLength" : buffer.byteLength, "target" : 34962}
	save_data.bufferViews = [buffer_view]
	
	var accessor := _create_accessor(topology)
	save_data.accessors = [accessor]

func _create_buffer(voxels: PoolVector3Array) -> Dictionary:
	var bytes := PoolByteArray()
	for vertex in voxels:
		var position: Vector3 = vertex
		bytes.append_array(_vector_to_bytes(position))
	var base64_raw := Marshalls.raw_to_base64(bytes)
	var base64 = "data:application/octet-stream;base64," + base64_raw
	return {"uri": base64, "byteLength": bytes.size()}

func _create_accessor(voxels: PoolVector3Array) -> Dictionary:
	var lower_bound := voxels[0]
	var upper_bound := voxels[0]
	for vertex in voxels:
		
		lower_bound.x = min(lower_bound.x, vertex.x)
		lower_bound.y = min(lower_bound.y, vertex.y)
		lower_bound.z = min(lower_bound.z, vertex.z)
		
		upper_bound.x = max(upper_bound.x, vertex.x)
		upper_bound.y = max(upper_bound.y, vertex.y)
		upper_bound.z = max(upper_bound.z, vertex.z)
		
	var accessor := {"bufferView": 0, "byteOffset": 0, "componentType": 5126, 
	"count": voxels.size(), 
	"type": "VEC3", 
	"min": [lower_bound.x, lower_bound.y, lower_bound.z], 
	"max": [upper_bound.x, upper_bound.y, upper_bound.z]}
	return accessor

func _vector_to_bytes(vector: Vector3) -> PoolByteArray:
	var stream := StreamPeerBuffer.new()
	stream.put_float(vector.x)
	stream.put_float(vector.y)
	stream.put_float(vector.z)
	stream.seek(0)
	print(stream.get_available_bytes())
	return stream.get_data(stream.get_available_bytes())[1]

func _print_bytes(bytes: PoolByteArray):
	var to_print := String()
	for byte in bytes:
		to_print += str(byte)
	print(to_print)
