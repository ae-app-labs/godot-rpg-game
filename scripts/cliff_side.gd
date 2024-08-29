extends Node2D

func _process(_delta: float) -> void:
	change_scene()
	
func _on_cliff_side_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transision_scene = true

func _on_cliff_side_exit_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transision_scene = false

func change_scene():
	if global.transision_scene:
		if global.current_scene == "cliff_side":
			global.current_scene = "world"
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_scene_transistion()
