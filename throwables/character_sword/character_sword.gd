extends ThrowableComponent

class_name CharacterSword

func _on_body_entered(_body) -> void:
	if _body is TileMap:
		queue_free()
