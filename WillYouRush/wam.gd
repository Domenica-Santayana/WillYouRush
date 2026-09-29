extends Node2D

var puntos = 0
var meta_puntos = 20 # Meta inicial para el Nivel 1

func _ready() -> void:
	# Aseguramos que la pantalla de victoria empiece oculta
	if has_node("congrats"):
		$congrats.hide()
		
	# Aseguramos que la pantalla de Game Over empiece oculta
	if has_node("gameover"):
		$gameover.hide()

	# Verificamos si venimos del Quiz con el Nivel 2 activo gracias al Autoload Global
	if Global.nivel_actual == 2:
		meta_puntos = 20 
		
		# Hacemos que el reloj dure 10 segundos en el Nivel 2
		if has_node("gameclock"):
			$gameclock.wait_time = 10.0
			
		# Ocultamos el cartel del Nivel 1 y mostramos el exclusivo del Nivel 2
		if has_node("instructions"):
			$instructions.hide()
		if has_node("instructions_lvl2"):
			$instructions_lvl2.show()
			
	else:
		# Si estamos en el Nivel 1, aseguramos que se vea el cartel normal y se oculte el del nivel 2
		if has_node("instructions"):
			$instructions.show()
		if has_node("instructions_lvl2"):
			$instructions_lvl2.hide()

	$marcador.text = "Points: " + str(puntos) + " / " + str(meta_puntos)
	$gameclock.timeout.connect(_on_gameclock_timeout)

func sumar_punto():
	puntos += 1
	$marcador.text = "Points: " + str(puntos) + " / " + str(meta_puntos)
	
	# Verificamos si alcanzamos la meta según el nivel en el que estemos
	if puntos >= meta_puntos:
		$gameclock.stop()
		get_tree().call_group("topos", "detener_topo")
		
		# Si estamos en nivel 1 saltamos al Quiz
		if Global.nivel_actual == 1:
			get_tree().change_scene_to_file("res://quiz.tscn")
		else:
			# ¡Ganaste todo el juego! Mostramos la pantallita de felicitaciones con la imagen
			if has_node("congrats"):
				$congrats.show()
			else:
				get_tree().change_scene_to_file("res://title_screen.tscn")

func _on_button_pressed() -> void:
	# Cuando el jugador hace clic en Jugar:
	if has_node("instructions"):
		$instructions.hide() 
	if has_node("instructions_lvl2"):
		$instructions_lvl2.hide()
		
	$gameclock.start() # Arranca el cronómetro
	get_tree().call_group("topos", "iniciar_topo") # ¡Despierta a todos los topos!

func _process(delta):
	# Esto obligará al texto a mostrar el tiempo del reloj en todo momento
	if not $gameclock.is_stopped():
		$timet.text = "Time: " + str(int($gameclock.time_left))
	
func _on_gameclock_timeout() -> void:
	# Si el reloj llega a 0 y no alcanzamos la meta
	if puntos < meta_puntos:
		# Muestra la pantalla de derrota (Game Over)
		if has_node("gameover"):
			$gameover.show()
		# Manda la orden de detenerse a todos los topos
		get_tree().call_group("topos", "detener_topo")

func _on_tryagain_pressed() -> void:
	# Si pierdes en el Nivel 2, reiniciamos el nivel global a 1 y volvemos al inicio (o al título)
	if Global.nivel_actual == 2:
		Global.nivel_actual = 1
		get_tree().change_scene_to_file("res://title_screen.tscn") # O puedes poner "res://wam.tscn" si prefieres que reinicie directo al Nivel 1
	else:
		# Si estabas en el Nivel 1, simplemente recarga la escena actual
		get_tree().reload_current_scene()

# Función para el botón de la pantalla de victoria (congrats) para volver al menú
func _on_menu_pressed() -> void:
	Global.nivel_actual = 1 # Reseteamos por seguridad al volver al menú
	get_tree().change_scene_to_file("res://title_screen.tscn")
