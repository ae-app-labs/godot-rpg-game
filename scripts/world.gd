extends Node2D

func _ready() -> void:
	if global.game_first_loading:
		$Player.position.x = global.player_start_pos_x
		$Player.position.y = global.player_start_pos_y
	else:
		$Player.position.x = global.player_exit_cliff_side_pos_x
		$Player.position.y = global.player_exit_cliff_side_pos_y

func _process(_delta: float) -> void:
	change_scenes()

func _on_cliff_side_transision_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transision_scene = true

func _on_cliff_side_transision_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transision_scene = false

func change_scenes():
	if global.transision_scene == true:
		if global.current_scene == "world":
			global.game_first_loading = false
			global.current_scene = "cliff_side"
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			global.finish_scene_transistion()
