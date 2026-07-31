extends StaticBody2D

func _ready() -> void:
	$Sprite.frame = [0, 1].pick_random()
	
func hit() -> void:
	var tween = create_tween()
	tween.tween_property($Sprite.material, "shader_parameter/progress", 1.0, 0.2)
	tween.tween_property($Sprite.material, "shader_parameter/progress", 0, 0.3)
