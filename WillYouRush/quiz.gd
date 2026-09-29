extends Node2D

var lista_preguntas = [
	{
		"pregunta": "15 + 17",
		"opciones": ["-2", "32", "22", "2"],
		"correcta": 1 
	},
	{
		"pregunta": "14 x 7",
		"opciones": ["45", "67", "98", "93"],
		"correcta": 2 
	},
	{
		"pregunta": "f'(lnx)",
		"opciones": ["1", "x", "2/x", "1/x"],
		"correcta": 3
	}
]

var indice_pregunta_actual = 0
var juego_terminado = false

func _ready() -> void:
	$Button1.pressed.connect(_on_opcion_pressed.bind(0))
	$Button2.pressed.connect(_on_opcion_pressed.bind(1))
	$Button3.pressed.connect(_on_opcion_pressed.bind(2))
	$Button4.pressed.connect(_on_opcion_pressed.bind(3))
	
	$quizclock.timeout.connect(_on_tiempo_agotado)
	
	# Detecta automáticamente tu botón de Game Over y lo conecta
	if has_node("PantallaGameOverQuiz"):
		$PantallaGameOverQuiz.hide()
		if $PantallaGameOverQuiz.has_node("Button"):
			$PantallaGameOverQuiz/Button.pressed.connect(_on_button_reintentar_pressed)
			
	# CONFIGURACIÓN DE INICIO:
	if has_node("PantallaInicioQuiz"):
		$PantallaInicioQuiz.show()
		# Conectamos tu botón 'start' correctamente
		if $PantallaInicioQuiz.has_node("start"):
			$PantallaInicioQuiz/start.pressed.connect(_on_button_start_pressed)

	# ⚠️ QUITAMOS 'cargar_pregunta()' de aquí para que espere al botón Start

func _on_button_start_pressed() -> void:
	# Ocultamos la pantalla de inicio y ahora sí arranca el juego de verdad
	if has_node("PantallaInicioQuiz"):
		$PantallaInicioQuiz.hide()
	
	cargar_pregunta()

func cargar_pregunta() -> void:
	if juego_terminado:
		return
		
	var actual = lista_preguntas[indice_pregunta_actual]
	
	$question.text = actual["pregunta"]
	$Button1.text = actual["opciones"][0]
	$Button2.text = actual["opciones"][1]
	$Button3.text = actual["opciones"][2]
	$Button4.text = actual["opciones"][3]
	
	$quizclock.start()

func _on_opcion_pressed(indice_seleccionado: int) -> void:
	if juego_terminado:
		return
		
	var actual = lista_preguntas[indice_pregunta_actual]
	
	if indice_seleccionado == actual["correcta"]:
		print("¡Correcto!")
		$quizclock.stop()
		
		indice_pregunta_actual += 1
		
		if indice_pregunta_actual < lista_preguntas.size():
			cargar_pregunta() 
		else:
			print("¡Has ganado el Quiz! Pasando al Nivel 2 de Topos...")
			juego_terminado = true
			$quizclock.stop()
			
			# Subimos el nivel global y regresamos a los topos
			Global.nivel_actual = 2
			get_tree().change_scene_to_file("res://wam.tscn")
	else:
		print("¡Incorrecto! Game Over.")
		activar_game_over()

func _on_tiempo_agotado() -> void:
	if juego_terminado:
		return
	print("¡Se acabó el tiempo del Quiz!")
	activar_game_over()

func activar_game_over() -> void:
	juego_terminado = true
	$quizclock.stop()
	
	if has_node("PantallaGameOverQuiz"):
		$PantallaGameOverQuiz.show()

func _process(delta: float) -> void:
	# Evitamos que el texto del tiempo cambie si la pantalla de inicio sigue abierta
	var inicio_activo = has_node("PantallaInicioQuiz") and $PantallaInicioQuiz.visible
	
	if not inicio_activo and not juego_terminado and not $quizclock.is_stopped():
		$TextoTiempoQuiz.text = "Time: " + str(int($quizclock.time_left))

func _on_button_reintentar_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
