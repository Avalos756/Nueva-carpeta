extends Node

func _ready():
	# El juego siempre arranca ocupando toda la pantalla (con barra)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_F11 and event.pressed:
		_alternar_pantalla_simple()

func _alternar_pantalla_simple():
	var modo_actual = DisplayServer.window_get_mode()
	
	if modo_actual == DisplayServer.WINDOW_MODE_FULLSCREEN:
		# Si está en pantalla completa, lo volvemos ventana grande
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		# Nos aseguramos de que tenga bordes para que no se achique
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	else:
		# ¡MODO FPS MÁXIMOS!
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
