extends Control



func _ready() -> void:
	
	# ¡Esta es la línea que despierta al ratón al entrar al menú!
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# 1. Efecto de fundido a negro
	$ColorRect.show() 
	$ColorRect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.0, 2.0)
	tween.tween_callback($ColorRect.hide)
	
	# ... (el resto de tu código de música y frases) ...
	
	# 1. Efecto de fundido a negro
	$ColorRect.modulate.a = 1.0
	tween.tween_property($ColorRect, "modulate:a", 0.0, 5.0)
	tween.tween_callback($ColorRect.hide)
	
	# 2. Música del menú
	if not MusicaGlobal.playing:
		MusicaGlobal.stream = load("res://AUDIOS/intromenu.mp3") 
		MusicaGlobal.play()
	
	# 3. Frases aleatorias
	var frases = ["¡Cuidado con las sombras!", "Hecho con amor y Godot", "No mires atrás", "5 días de locura"]
	$LabelSplash.text = frases.pick_random()
	
	efecto_minecraft()






func _on_button_3_pressed() -> void:
	# Esto esconde el grupo de botones principales
	$VBoxContainer.hide() 
	var ajustes = load("res://ESCENAS/MENU E INTRO/config.tscn").instantiate()
	add_child(ajustes)



func _on_button_4_pressed() -> void:
	get_tree().quit()


func _on_button_pressed():
	# 1. Apagamos la música del menú al instante
	MusicaGlobal.stop()
	
	# 2. Hacemos visible el cuadro negro que usamos en la intro
	$ColorRect.show()
	
	# 3. Creamos un nuevo tween para que pase de transparente (0.0) a negro total (1.0)
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 1.5) # Tarda 1.5 segundos
	
	# 4. Le decimos: "Oye, cuando termines de ponerte negro, llama a esta otra función"
	tween.tween_callback(ir_al_juego)

# Creamos esta función nueva justo debajo para cambiar la escena
func ir_al_juego():
	get_tree().change_scene_to_file("res://ESCENAS/NIVELES/level_1.tscn")


func _on_button_5_pressed():
	# Le decimos: "DJ, ponme la Intro con esta otra canción"
	MusicaGlobal.cambiar_todo("res://ESCENAS/MENU E INTRO/intro juego.tscn", "res://AUDIOS/musica_intro.ogg")




# ESTO VA AL FINAL DEL TODO, PEGADO AL BORDE IZQUIERDO
func efecto_minecraft():
	# Esto centra el punto de crecimiento para que no se mueva de su sitio
	$LabelSplash.pivot_offset = $LabelSplash.size / 2
	
	var tween = create_tween().set_loops()
	# Se agranda y achica (puedes cambiar 1.2 por 1.4 si quieres que salte más)
	tween.tween_property($LabelSplash, "scale", Vector2(1.2, 1.2), 0.5)
	tween.tween_property($LabelSplash, "scale", Vector2(1.0, 1.0), 0.5)
