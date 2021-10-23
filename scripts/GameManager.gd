extends Node


const EXAMPLES = {
		STABLE = [
			[0,0,0,0,0],
			[0,0,1,0,0],
			[0,1,0,1,0],
			[0,1,0,1,0],
			[0,0,1,0,0],
			[0,0,0,0,0],
		],

		GLIDER = [
			[0,0,0,0,0,0],
			[0,0,0,0,0,0],
			[0,0,1,0,0,0],
			[0,0,0,1,1,0],
			[0,0,1,1,0,0],
			[0,0,0,0,0,0]
		],

		SMALL_EXPLODER = [
			[0,0,0,0,0],
			[0,0,1,0,0],
			[0,1,1,1,0],
			[0,1,0,1,0],
			[0,0,1,0,0],
			[0,0,0,0,0]
		]
}


const CELL := preload("res://scenes/Cell.tscn")
var CELL_SIZE := Vector2(48,48)
var clicked_cell = null
var cells_dict : Dictionary
var cells_neighbors := {}
var mouse_click_held := false
var mouse_drag_state := true
var touch_event_mode = -1 # 0: remove mode, 1: add mode, -1: both
var timer : Timer


func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 0.3
	get_node("/root/Main").add_child(timer)
	timer.connect("timeout", self, "compute_next_generation")

func update_cells_colors(alive : Color, dead : Color) -> void:
	for cell in cells_dict.values():
		cell.dead_color = dead
		cell.alive_color = alive
		cell.state = !cell.state
		cell.state = !cell.state


func select_cell(cell) -> bool:
	clicked_cell = cell
	if touch_event_mode == 0:
		clicked_cell.state = false
	elif touch_event_mode == 1:
		clicked_cell.state = true
	else:
		clicked_cell.state = !clicked_cell.state
	return clicked_cell.state


func get_neighbors(cell) -> Array:
	if !(cell in cells_neighbors):
		var gp = cell.grid_position
		var ngp := [
			Vector2(gp.x - 1, gp.y - 1),
			Vector2(gp.x - 1, gp.y),
			Vector2(gp.x - 1, gp.y + 1),
			Vector2(gp.x, gp.y + 1),
			Vector2(gp.x, gp.y - 1),
			Vector2(gp.x + 1, gp.y - 1),
			Vector2(gp.x + 1, gp.y),
			Vector2(gp.x + 1, gp.y + 1)
		]
		cells_neighbors[cell] = []
		for p in ngp:
			if p in cells_dict:
				cells_neighbors[cell].append(p)
	return cells_neighbors[cell]


func toggle_add_cell_mode():
	touch_event_mode = 1

func toggle_remove_cell_mode():
	touch_event_mode = 0

func toggle_dual_cell_mode():
	touch_event_mode = -1

func reset_grid():
	for cell in cells_dict.values():
		cell.state = false

func start_timer() -> void:
	timer.start()
	

func stop_timer() -> void:
	timer.stop()	

func compute_next_generation() -> void:
	var cells_to_turn_alive := []
	var cells_to_turn_dead := []
	for cell_pos in cells_dict:
		var ns_pos = get_neighbors(cells_dict[cell_pos])
		var ns_state := {true:0, false:0}
		for nsp in ns_pos:
			ns_state[cells_dict[nsp].state] += 1
		if (cells_dict[cell_pos].state and (ns_state[true] == 2 or ns_state[true] == 3)) or (!cells_dict[cell_pos].state and ns_state[true] == 3):
			cells_to_turn_alive.append(cells_dict[cell_pos])
		else:
			cells_to_turn_dead.append(cells_dict[cell_pos])
	for cell in cells_to_turn_alive:
		cell.state = true
	for cell in cells_to_turn_dead:
		cell.state = false
	emit_signal("next_generation")

