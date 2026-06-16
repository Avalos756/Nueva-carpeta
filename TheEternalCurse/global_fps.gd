extends CanvasLayer

# Cambia $Label por el nombre exacto de tu nodo de texto si le cambiaste el nombre
func _process(_delta: float) -> void:
	$Label.text = "FPS: " + str(Engine.get_frames_per_second())
