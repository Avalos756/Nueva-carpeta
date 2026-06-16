extends AudioStreamPlayer

func cambiar_todo(ruta_escena, ruta_audio):
	# 1. Cambiamos de escena al toque
	get_tree().change_scene_to_file(ruta_escena)
	
	# 2. Si hay una ruta de audio nueva, cambiamos la canción
	if ruta_audio != "" and FileAccess.file_exists(ruta_audio):
		stream = load(ruta_audio)
		play()
		volume_db = 0 # Nos aseguramos que el volumen esté arriba
	elif ruta_audio == "STOP":
		stop() # Si quieres silencio en el nivel 1
