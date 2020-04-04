extends Node2D

const WIDTH = 100 # сколькл ячеек генерировать
const HEIGHT = 30 # высота земной коры
const HEIGHT_ = 100 # высота земной коры

const CENTER_Y = 4 # середина мира по вертикали

const NOISE_PREDEL = -0.05
const generate_to_end = 30 # за сколко ячеек до конца начинать новую генерацию


var current_world_end = 0 # текущий край земли
var delta_sum = 0 # сумма дельты для проверки раз в секунду

var enemy_tscn = preload("res://enemy/firstEnemy/firstEnemy.tscn")


var noise


func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()

	noise.octaves = 4
	noise.period = 8
	noise.lacunarity = 2
	noise.persistence = 0.25
	generate_world_with_caves()
	
	generate_enemy(10)

func create_enemy(pos):
	var enemy = enemy_tscn.instance()
	enemy.position = pos
	self.add_child(enemy)

func generate_enemy(step):
	for x in range(current_world_end + rand_range(-5, 5), current_world_end + WIDTH):
		if x % step == 0:
			for y in range(0, HEIGHT_):
				if $TileMap.get_cell(x, y) != -1 and $TileMap.get_cell(x, y-1) == -1:
					var pos = $TileMap.map_to_world(Vector2(x, y-1), true)
					create_enemy(pos)
		
		
func generate_world_with_caves():
	for x in range(current_world_end, current_world_end + WIDTH):
		for y in range(0, current_world_end + HEIGHT_):
			noise.get_noise_2d(x, y)
			var qwe = noise.get_noise_2d(x, y)
			if qwe >= NOISE_PREDEL:
				var tile_index = 0
				if $TileMap.get_cell(x, y-1) != -1:
					tile_index = 1
				$TileMap.set_cellv(Vector2(x, y), tile_index)

	
func generate_world_flat():
	for x in range(current_world_end, current_world_end + WIDTH):
		var delta_y = int(noise.get_noise_2d(x, CENTER_Y) * 10)
		var y = CENTER_Y + delta_y
		$TileMap.set_cellv(Vector2(x, y), 0)
		for i in range(y + 1, HEIGHT):
			$TileMap.set_cellv(Vector2(x, i), 1)
	current_world_end += WIDTH

#func _process(delta):
#	delta_sum += delta
#	if delta_sum > 1:
#		if (current_world_end - $TileMap.world_to_map($player.position).x) < generate_to_end:
#			generate_world()
#		delta_sum = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				print(123)
				if self.scale.x < 2:
					self.scale += Vector2(0.1, 0.1)
			if event.button_index == BUTTON_WHEEL_DOWN:
				print(321)
				if self.scale.x > 0.1:
					self.scale -= Vector2(0.1, 0.1)
					print(self.get_children())
			
