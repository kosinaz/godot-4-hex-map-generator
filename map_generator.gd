extends Node2D

var width = 160
var height = 62

# The width of the island's coastline. The higher the number, the more gentle 
# the slope will be, and the more natural it will look.
var left_margin = 10.0
var right_margin = 10.0
var top_margin = 10.0
var bottom_margin = 10.0

@onready 
var tilemap = $TileMap

var map = {}

var noise = FastNoiseLite.new()

# The row of the tileset to be used for the map. Either natural or debug.
var tileset = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	
	# The lower the frequency is, the wider the map features 
	# (grasslands, forest, lakes, mountains) will be.
	noise.frequency = 0.08
	
	# The more octaves, the less smoothly separated the map features will be.
	noise.fractal_octaves = 2
	
	generate_map()
	set_tiles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("generate"):
		get_tree().reload_current_scene()

func generate_map():
	noise.seed = randi()
	for x in width:
		for y in height:
			
			# Get a noise value between -1 and 1
			var elevation = noise.get_noise_2d(x, y)
			
			# Make it positive, changing the range to 0 to 2
			elevation += 1.0
			
			# Maximize it in 1, range is now 0 to 1
			elevation /= 2.0
			
			# Reserve an additional modifier to lower the borders
			var modifier = 0.0
			
			# The closer to the left.
			if x < left_margin:
				
				# The more we take away from the max height of 1.
				modifier += (left_margin - x) / left_margin
			
			# The closer to the right.
			if x > width - right_margin:
				
				# The more we take away from the max height of 1.
				modifier += (right_margin + x - width) / right_margin
			
			# The closer to the top.
			if y < top_margin:
				
				# The more we take away from the max height of 1.
				modifier += (top_margin - y) / top_margin
			
			# The closer to the bottom.
			if y > height - bottom_margin:
				
				# The more we take away from the max height of 1.
				modifier += (bottom_margin + y - height) / bottom_margin
			
			# Show modifier margin.
#			if x == left_margin or y == top_margin or x == width - right_margin or y == height - bottom_margin:
#				elevation = 0
			
			# Reduce the elevation with the modifier but never go under 0.2.
			elevation = max(elevation - modifier, 0.2)
			
			# Set the elevation.
			map[Vector2(x, y)] = elevation


func set_tiles():
	for pos in map:
		var elevation = map[pos]
		if elevation > 0.9:
			tilemap.set_cell(0, pos, 0, Vector2(9, tileset))
		elif elevation > 0.8:
			tilemap.set_cell(0, pos, 0, Vector2(8, tileset))
		elif elevation > 0.7:
			tilemap.set_cell(0, pos, 0, Vector2(7, tileset))
		elif elevation > 0.6:
			tilemap.set_cell(0, pos, 0, Vector2(6, tileset))
		elif elevation > 0.5:
			tilemap.set_cell(0, pos, 0, Vector2(5, tileset))
		elif elevation > 0.4:
			tilemap.set_cell(0, pos, 0, Vector2(4, tileset))
		elif elevation > 0.3:
			tilemap.set_cell(0, pos, 0, Vector2(3, tileset))
		elif elevation > 0.2:
			tilemap.set_cell(0, pos, 0, Vector2(2, tileset))
		elif elevation > 0.1:
			tilemap.set_cell(0, pos, 0, Vector2(1, tileset))
		else:
			tilemap.set_cell(0, pos, 0, Vector2(0, tileset))
