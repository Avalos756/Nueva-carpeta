
extends Control




func _on_button_4_pressed() -> void:
	# 1. Buscamos el grupo de botones del menú y lo mostramos de nuevo
	# Usamos 'find_child' porque es más seguro que 'get_parent'
	var menu_botones = get_tree().root.find_child("VBoxContainer", true, false)
	
	if menu_botones:
		menu_botones.show()
	
	# 2. Borramos la escena de configuración para volver al menú
	# ¡OJO! No uses change_scene aquí, solo queue_free
	queue_free()
