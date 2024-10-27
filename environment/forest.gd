extends GridMap

# Range for size scaling
var min_scale = 0.8
var max_scale = 1.2
# Range for rotation
var min_rotation = -180  # Degrees
var max_rotation = 180    # Degrees

func _ready():
	# Get all non-empty meshes in the GridMap
	var meshes = get_meshes()
	
	# Iterate through the meshes array
	for index in range(meshes.size()/2):
		var mesh_transform = meshes[index*2]
		
		# Get the original cell position from the transform
		var position = mesh_transform.origin
		
		# Generate random scale
		var scale_factor = randf_range(min_scale, max_scale)

		# Generate random rotation around the Y-axis (in radians)
		var rotation_y = deg_to_rad(randf_range(min_rotation, max_rotation))

		# Create a new Transform based on the existing one
		var new_transform = Transform3D()
		new_transform.origin = position  # Keep the same position
		
		# Create a basis with the new scale and rotation
		new_transform.basis = Basis().scaled(Vector3(scale_factor, scale_factor, scale_factor)).rotated(Vector3.UP, rotation_y)

		# Retrieve the cell coordinates based on the position
		var cell_x = position.x
		var cell_z = position.z

		# Set the new item and apply the new orientation (0 for no rotation if not needed)
		set_cell_item(Vector3i(cell_x, 0, cell_z), get_cell_item(Vector3i(cell_x, 0, cell_z)), 0)
