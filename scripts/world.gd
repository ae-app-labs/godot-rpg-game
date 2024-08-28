extends Node2D


func _on_cliff_side_transision_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transision_scene = true


func _on_cliff_side_transision_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transision_scene = false
