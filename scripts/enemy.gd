extends CharacterBody2D

var speed = 45
var player_chase = false
var player = null

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	if player_chase:
		print("chasing player")
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		if (player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	print("area entered")
	player = body
	player_chase = true

func enemy():
	pass
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	print("area exited")
	player = null
	player_chase = false
