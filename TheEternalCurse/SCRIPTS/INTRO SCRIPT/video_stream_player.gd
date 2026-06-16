extends VideoStreamPlayer

func _ready():
	play()
	finished.connect(_on_finished)

func _cambiar_al_menu():
	# REVISA QUE ESTA RUTA SEA EXACTA
	get_tree().change_scene_to_file("res://ESCENAS/MENU E INTRO/menu.tscn")


func _on_finished():
	_cambiar_al_menu()



func _on_skip_button_pressed() -> void:
	_cambiar_al_menu()
