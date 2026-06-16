extends Node2D 

@onready var menu_pausa = $"IU/MENU DE PAUSA IN GAME_CanvasLayer"
@onready var mundo = $MUNDO # El nodo que creaste arriba

func _ready():
	
	# IMPORTANTE: Asegúrate de que la ruta coincida con el nombre que le pusiste a tu CanvasLayer
	var pantalla_negra = $CanvasLayer/ColorRect
	
	# Empezamos todo en negro
	pantalla_negra.show()
	pantalla_negra.modulate.a = 1.0
	
	# Hacemos el fundido de aparición
	var tween = create_tween()
	tween.tween_property(pantalla_negra, "modulate:a", 0.0, 2.0)
	tween.tween_callback(pantalla_negra.hide)
	
	# El nivel base siempre debe procesar para detectar el ESC
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		pausar_despausar()

func pausar_despausar():
	var esta_pausado = !get_tree().paused
	get_tree().paused = esta_pausado
	
	# FORZAR la detención de todo lo que esté en el nodo MUNDO
	if esta_pausado:
		mundo.process_mode = Node.PROCESS_MODE_DISABLED
		menu_pausa.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		mundo.process_mode = Node.PROCESS_MODE_INHERIT
		menu_pausa.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)




#provando 
# no //no? 
