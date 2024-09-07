extends ParallaxBackground

class_name Background

#so será chamado quando iniciado o jogo
@onready var _clouds: Array = [
	$CloudT1, $CloudT2, $CloudT3, $CloudT4,
	 $CloudT5, $CloudT6, $CloudT7, $CloudT8
]

# tudo relacionado a processos como inputs, cliques de interface,
# ações para monitorar, etc
func _process(delta):
	pass

var speed_values: Array[float] = [
	16.0, 16.0, 4.0, 4.0, 8.0, 8.0, 12.0, 12.0
]
# tudo em relação a algo fisico, movimentação de personagens e 
# movimentação de objetos
func _physics_process(delta: float) -> void:
	var _i: int = 0
	for cloud in _clouds:
		cloud.motion_offset.x -= speed_values[_i] * delta
		_i += 1
