extends Node2D

@export
var width = 160

@export
var height = 62

@onready 
var tilemap = $TileMap

var altitude = {}

var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	
	# The lower the frequency is, the wider the map features 
	# (grasslands, lakes, mountains) will be.
	noise.frequency = 0.1
#	noise.fractal_octaves = 8
	altitude = generate_map()
	set_tile(width, height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("generate"):
		get_tree().reload_current_scene()

func generate_map():
	noise.seed = randi()
	var map = {}
	for x in width:
		for y in height:
			
			# Get a noise value between -1 and 1
			var elevation = noise.get_noise_2d(x, y)
			
			# Make it positive, changing the range to 0 to 2
			elevation += 1.0
			
			# Maximize it in 1, range is now 0 to 1
			elevation /= 2.0
			
#			var rand = 2 * (abs(noise.get_noise_2d(x, y)))
#			var nx = 2.0 * x / width - 1
#			var ny = 2.0 * y / height - 1
#			var d = 1 - (1 - pow(nx, 2)) * (1 - pow(ny, 2))
#			rand /= 2
#			rand = pow(rand, 4)
#			rand = (rand + (1 - d)) / 2
			map[Vector2(x, y)] = elevation
	return map

func set_tile(w, h):
	for x in w:
		for y in h:
			var pos = Vector2(x, y)
			var alt = altitude[pos]
			
			if alt > 0.9:
				tilemap.set_cell(0, pos, 0, Vector2(9, 0))
			elif alt > 0.8:
				tilemap.set_cell(0, pos, 0, Vector2(8, 0))
			elif alt > 0.7:
				tilemap.set_cell(0, pos, 0, Vector2(7, 0))
			elif alt > 0.6:
				tilemap.set_cell(0, pos, 0, Vector2(6, 0))
			elif alt > 0.5:
				tilemap.set_cell(0, pos, 0, Vector2(5, 0))
			elif alt > 0.4:
				tilemap.set_cell(0, pos, 0, Vector2(4, 0))
			elif alt > 0.3:
				tilemap.set_cell(0, pos, 0, Vector2(3, 0))
			elif alt > 0.2:
				tilemap.set_cell(0, pos, 0, Vector2(2, 0))
			elif alt > 0.1:
				tilemap.set_cell(0, pos, 0, Vector2(1, 0))
			else:
				tilemap.set_cell(0, pos, 0, Vector2(0, 0))
