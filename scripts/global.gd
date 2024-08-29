extends Node

var player_current_attack = false

var current_scene = "world"
var transision_scene  = false

var player_exit_cliff_side_pos_x = 277
var player_exit_cliff_side_pos_y = 20

var player_start_pos_x = 78
var player_start_pos_y = 136

var game_first_loading = true

func finish_scene_transistion():
	if transision_scene == true:
		transision_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
