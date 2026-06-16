extends CanvasLayer



func _on_button_4_pressed() -> void:
	# 1. Buscamos el menú de pausa en el juego y lo volvemos a mostrar
	# Esta línea busca el nodo que escondimos antes
	var menu_pausa = get_tree().root.find_child("MENU DE PAUSA IN GAME_CanvasLayer", true, false)
	
	if menu_pausa:
		menu_pausa.show() # ¡Aparece de nuevo!
	
	# 2. Ahora sí, cerramos los ajustes
	queue_free()
