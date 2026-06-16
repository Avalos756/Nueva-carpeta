extends CanvasLayer

func _on_button_pressed() -> void: # Botón CONTINUAR
	get_tree().paused = false
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_button_3_pressed() -> void: # Botón MENU PRINCIPAL
	get_tree().paused = false
	# Ajusté la ruta a mayúsculas como se ve en tu carpeta ESCENAS
	var error = get_tree().change_scene_to_file("res://ESCENAS/MENU E INTRO/menu.tscn")
	if error != OK:
		print("Error: No se encuentra la escena del menú. Revisa el nombre en la carpeta ESCENAS")

func _on_button_2_pressed() -> void: # Botón AJUSTES
	hide()
	# Asegúrate de que este nombre sea EXACTO al de tu archivo en la carpeta ESCENAS
	var ajustes_escena = load("res://ESCENAS/MENU E INTRO/pausa_ajustes__canvas_layer.tscn")
	if ajustes_escena:
		var ajustes = ajustes_escena.instantiate()
		get_tree().root.add_child(ajustes)
	else:
		print("Error: No se pudo cargar la escena de ajustes")

func _on_button_4_pressed() -> void: # Botón SALIR
	get_tree().quit()
