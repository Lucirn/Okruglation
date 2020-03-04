extends Node2D

const WIDTH = 100
const HEIGHT = 30
const CENTER_Y = 4
var noise


func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 15
	noise.lacunarity = 2
	noise.persistence = 0.25
	
	generate_world()
	
func generate_world():
	for x in WIDTH:
		var delta_y = int(noise.get_noise_2d(x, CENTER_Y) * 10)
		var y = CENTER_Y + delta_y
		$TileMap.set_cellv(Vector2(x, y), 0)
		for i in range(y + 1, HEIGHT):
			$TileMap.set_cellv(Vector2(x, i), 1)
