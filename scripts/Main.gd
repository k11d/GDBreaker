extends Node


onready var grid_viewport = $ViewportContainer/Viewport
onready var grid = $ViewportContainer/Viewport/Grid
var cells := [{}, {}]
var dead_color := Color.gray
var alive_color := Color.cyan


func _ready() -> void:
	spawn_grid()
	GameManager.update_cells_colors(alive_color, dead_color)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_ViewportContainer_resized() -> void:
	print("viewport resized")
	var win = $ViewportContainer.get_rect().size
	print(win)


func spawn_grid() -> void:	
	grid_viewport.size = Vector2(OS.get_screen_size().x, OS.get_screen_size().y - 50)
	
	var count_x = floor(grid_viewport.size.x / GameManager.CELL_SIZE.x)
	var count_y = floor(grid_viewport.size.y / GameManager.CELL_SIZE.y) - 1

	var gpos : Vector2
	var rpos : Vector2
	var cell := GameManager.CELL.instance()
	for y in range(count_y):
		for x in range(count_x):
			gpos = Vector2(x,y)
			rpos = gpos * GameManager.CELL_SIZE + GameManager.CELL_SIZE / 2
			cells[0][gpos] = cell.duplicate(DUPLICATE_USE_INSTANCING)
			grid.add_child(cells[0][gpos])
			cells[0][gpos].position = rpos
			cells[0][gpos].grid_position = gpos
	GameManager.cells_dict = cells[0]
