extends Node2D

var puntos = 0

func sumar_punto():
	puntos += 1
	$Marcador.text = "Puntos: " + str(puntos)
