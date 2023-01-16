extends Node2D

@export
var width = 60

@export
var height = 40

@onready 
var tilemap = $TileMap

var altitude = {}

var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = 0.075
	noise.fractal_octaves = 1
	altitude = generate_map()
	set_tile(width, height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("generate"):
		get_tree().reload_current_scene()

func generate_map():
	noise.seed = randi()
	var gridName = {}
	for x in width:
		for y in height:
			var rand = 2 * (abs(noise.get_noise_2d(x, y)))
			var nx = 2.0 * x / width - 1
			var ny = 2.0 * y / height - 1
			var d = 1 - (1 - pow(nx, 2)) * (1 - pow(ny, 2))
			rand /= 2
			rand = pow(rand, 4)
			rand = (rand + (1 - d)) / 2
			gridName[Vector2(x, y)] = rand
	return gridName

func set_tile(w, h):
	for x in w:
		for y in h:
			var pos = Vector2(x, y)
			var alt = altitude[pos]
			
			if alt > 0.72:
				tilemap.set_cell(0, pos, 3, Vector2(4, 2))
			elif alt > 0.55:
				tilemap.set_cell(0, pos, 3, Vector2(3, 2))
			elif alt > 0.5:
				tilemap.set_cell(0, pos, 3, Vector2(2, 1))
			elif alt > 0.44:
				tilemap.set_cell(0, pos, 3, Vector2(1, 1))
			elif alt > 0.42:
				if (y > height / 2.0):
					tilemap.set_cell(0, pos, 3, Vector2(0, 1))
				else:
					tilemap.set_cell(0, pos, 3, Vector2(1, 1))
			elif alt > 0.36:
				tilemap.set_cell(0, pos, 3, Vector2(2, 0))
			else:
				tilemap.set_cell(0, pos, 3, Vector2(1, 0))
