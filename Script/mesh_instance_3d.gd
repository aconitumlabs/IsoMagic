extends Node3D

@export var velocidade_rotacao = 1.0

func _process(delta):
  rotate_y(velocidade_rotacao * delta)
  rotate_x(velocidade_rotacao * 0.5 * delta)
