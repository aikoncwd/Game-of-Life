extends Control

var height : int
var width : int
var matrix = []
var matrix_tmp
var started = false

func _ready():
	randomize()
	height = 55
	width = 100
	for x in range(width):
		matrix.append([])
		matrix[x] = []
		for y in range(height):
			matrix[x].append([])
			matrix[x][y] = 0
	
	matrix[49][23] = 1
	matrix[50][23] = 1
	matrix[50][24] = 1
	matrix[50][25] = 1
	matrix[51][24] = 1

	matrix_tmp = matrix.duplicate(true)
	update_board()
	
func update_board():
	for x in width:
		for y in height:
			$TileMap.set_cell(x, y, matrix[x][y])

func get_living_neighbors(x, y):
	var vecinos = 0
	for i in range(-1,2):
		for j in range(-1,2):
			if i != 0 or j != 0:
				if matrix[int(x + i + width) % width][int(y + j + height) % height]: vecinos += 1
	return vecinos

func step():
	if !started: return
	for y in height:
		for x in width:
			var vecinos = get_living_neighbors(x,y)
			if matrix[x][y]:
				if vecinos < 2 or vecinos > 3:
					matrix_tmp[x][y] = 0
				elif vecinos == 2 or vecinos == 3:
					matrix_tmp[x][y] = 1
			elif vecinos == 3:
				matrix_tmp[x][y] = 1
	
	matrix = matrix_tmp.duplicate(true)

func _input(event):
	if event is InputEventMouseButton:
		var x = (get_global_mouse_position().x - $TileMap.position.x) / 10
		var y = (get_global_mouse_position().y - $TileMap.position.y) / 10
		
		if y > 0:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				matrix[x][y] = 1

			if Input.is_mouse_button_pressed(BUTTON_RIGHT):
				matrix[x][y] = 0
			update_board()

func _process(delta):
	if started:
		OS.set_window_title("Game of Life - Running")
		step()
		update_board()
	else:
		OS.set_window_title("Game of Life - Sleeping")
	
func _on_button_startstop_pressed():
	started = !started

func _on_button_clear_pressed():
	started = true
	for y in height:
		for x in width:
			matrix[x][y] = 0
			matrix_tmp[x][y] = 0
	step()
	update_board()
	started = false
			
func _on_button_step_pressed():
	started = true
	step()
	update_board()
	started = false

func _on_button_random_pressed():
	for y in height:
		for x in width:
			matrix[x][y] = randi() % 2
	update_board()
