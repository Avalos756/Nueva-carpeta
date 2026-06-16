extends Control

@onready var logos = [$TextureRect, $TextureRect2]

func _ready():
	_reproducir_intro()

func _reproducir_intro():
	for logo in logos:
		# 1. Aparecer (Niebla entrando)
		var tween_in = create_tween()
		tween_in.tween_property(logo, "modulate:a", 0.5, 1.0) # 1.0 segundos
		await tween_in.finished # Espera a que termine de aparecer
		
		# 2. Mantener (Dura 1 segundos)
		await get_tree().create_timer(1.0).timeout
		
		# 3. Desaparecer (Niebla saliendo)
		var tween_out = create_tween()
		tween_out.tween_property(logo, "modulate:a", 0.0, 1.0)
		await tween_out.finished
		
	# Al final de todos los logos, cambiamos a la escena del video
	get_tree().change_scene_to_file("res://ESCENAS/MENU E INTRO/intro juego.tscn")
