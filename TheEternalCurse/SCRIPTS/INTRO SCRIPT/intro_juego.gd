extends Control

func _ready() -> void:
	# Nos aseguramos de que empiece oculto o visible según prefieras
	pass

# Variables para el mouse
var tiempo_inactivo: float = 0.0
var raton_oculto: bool = false # Nuestro interruptor

# ... (aquí sigue tu código de _process e _input) ...


func _process(delta: float) -> void:
	tiempo_inactivo += delta
	
	# Si pasa 1 segundo Y el ratón NO está oculto todavía...
	if tiempo_inactivo >= 1.0 and not raton_oculto:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		raton_oculto = true # Apagamos el interruptor para no repetirlo

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		tiempo_inactivo = 0.0
		
		# Solo lo volvemos a mostrar si estaba oculto
		if raton_oculto:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			raton_oculto = false



func _cambiar_al_menu():
	# ¡Esta es la línea mágica que fuerza al ratón a aparecer!
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	
	# Y luego ya cambias de escena normal
	get_tree().change_scene_to_file("res://ESCENAS/MENU E INTRO/menu.tscn")
