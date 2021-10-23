extends CanvasLayer
class_name UI



func _on_Both_pressed() -> void:
	GameManager.toggle_dual_cell_mode()
	$HBoxContainer/Both.self_modulate = Color.green
	$HBoxContainer/Remove.self_modulate = Color.white
	$HBoxContainer/Add.self_modulate = Color.white


func _on_Add_pressed() -> void:
	GameManager.toggle_add_cell_mode()
	$HBoxContainer/Both.self_modulate = Color.white
	$HBoxContainer/Remove.self_modulate = Color.white
	$HBoxContainer/Add.self_modulate = Color.green


func _on_Remove_pressed() -> void:
	GameManager.toggle_remove_cell_mode()
	$HBoxContainer/Both.self_modulate = Color.white
	$HBoxContainer/Remove.self_modulate = Color.green
	$HBoxContainer/Add.self_modulate = Color.white


func _on_ButtonReset_pressed() -> void:
	$HBoxContainer/GenCounter/Value.text = "0"
	GameManager.reset_grid()
	if $HBoxContainer/ButtonPlay.text == "Pause":
		GameManager.compute_next_generation()
		$HBoxContainer/GenCounter/Value.text = str(int($HBoxContainer/GenCounter/Value.text) + 1)


func _on_ButtonPlay_pressed() -> void:
	if $HBoxContainer/ButtonPlay.text == "Play":
		GameManager.start_timer()
		$HBoxContainer/ButtonPlay.text = "Pause"
		$HBoxContainer/ButtonPlay.self_modulate = Color.green
	else:
		GameManager.stop_timer()		
		$HBoxContainer/ButtonPlay.text = "Play"
		$HBoxContainer/ButtonPlay.self_modulate = Color.white


func _on_ButtonNext_pressed() -> void:
	GameManager.compute_next_generation()
	$HBoxContainer/GenCounter/Value.text = str(int($HBoxContainer/GenCounter/Value.text) + 1)



