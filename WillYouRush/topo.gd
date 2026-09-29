extends Area2D

func _ready() -> void:
	# Esta línea obliga a TODOS los topos a unirse al grupo sin importar nada
	add_to_group("topos")
	$Timer.wait_time = randf_range(0.8, 2.0)
	if randf() > 0.5:
		hide()
	else:
		show()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if visible:
			recibir_golpe()

func recibir_golpe():
	hide()
	print("¡Topo golpeado!")
	get_parent().sumar_punto()
	$Timer.wait_time=randf_range(0.5,1.5)
	$Timer.start()

func _on_timer_timeout() -> void:
	if visible:
		hide()
	else:
		show()
	$Timer.wait_time = randf_range(0.8, 2.0)
	$Timer.start()

func iniciar_topo():
	$Timer.start()

func detener_topo():
	$Timer.stop()
	hide() # Esconde los topos para limpiar el tablero
