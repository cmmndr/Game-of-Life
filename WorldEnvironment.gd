extends Node

onready var tilemap = get_child(0)
onready var timer = get_child(1)

func _ready():
	timer.connect("timeout", self, "update")
	timer.set_wait_time(0.1)
	timer.set_one_shot(false)
	timer.start()
	pass


func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		timer.set_paused(true)
		var mousePos = get_viewport().get_mouse_position()
		var location = tilemap.world_to_map(mousePos)
		var cell = tilemap.get_cell(location.x, location.y)
		if(cell != -1):
			tilemap.set_cell(location.x, location.y, 0)
	else:
		if(timer.is_paused()):
			timer.set_paused(false)


func update():
	checkGeneration()


func checkGeneration():
	var alive_cells = tilemap.get_used_cells_by_id(0)
	var dead_cells = tilemap.get_used_cells_by_id(1)
	for cell in alive_cells:
		var alive_neighbours = get_alive_neighbours(cell, alive_cells)
		rule_alive(cell, alive_neighbours)

	for cell in dead_cells:
		var alive_neighbours = get_alive_neighbours(cell, alive_cells)
		rule_dead(cell, alive_neighbours)

func get_alive_neighbours(cell, alive_cells):
	var neighbours = []
	var uu = Vector2(cell.x,cell.y-1)
	var ur = Vector2(cell.x+1,cell.y-1)
	var mr = Vector2(cell.x+1,cell.y)
	var br = Vector2(cell.x+1,cell.y+1)
	var bb = Vector2(cell.x,cell.y+1)
	var bl = Vector2(cell.x-1,cell.y+1)
	var ml = Vector2(cell.x-1,cell.y)
	var ul = Vector2(cell.x-1,cell.y-1)
	for alive_cell in alive_cells:
		if(alive_cell == uu or alive_cell == ur or alive_cell == mr or alive_cell == br or
		alive_cell == bb or alive_cell == bl or alive_cell == ml or alive_cell == ul):
			neighbours.append(alive_cell)

	return neighbours


func rule_alive(cell, alive_neighbours):
	if(alive_neighbours.size() < 2):
		tilemap.set_cell(cell.x, cell.y, 1) 
	elif(alive_neighbours.size() >= 2 and alive_neighbours.size() <= 3):
		tilemap.set_cell(cell.x,cell.y, 0)
	elif(alive_neighbours.size() > 3):
		tilemap.set_cell(cell.x, cell.y, 1)

func rule_dead(cell, alive_neighbours):
	if(alive_neighbours.size() == 3):
		tilemap.set_cell(cell.x, cell.y, 0)