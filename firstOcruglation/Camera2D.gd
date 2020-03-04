extends Camera2D

onready var player = $"../player"


func _process(delta):
	var pos = player.position
	var v = get_viewport_rect().size
	pos.x -= v.x / 2
	pos.y -= v.y / 2
	if pos.x < 0:
		pos.x = 1
	self.position = pos
