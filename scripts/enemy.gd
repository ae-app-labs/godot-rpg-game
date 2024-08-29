extends CharacterBody2D

var speed = 45
var player_chase = false
var player = null

var health = 100
var player_in_attack_zone = false
var can_take_damage = true

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		if (player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func enemy():
	pass

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false
		
func deal_with_damage():
	if player_in_attack_zone and global.player_current_attack == true:
		if can_take_damage:
			print("enemy health ", health)
			health -= 20
			$DamageCooldownTimer.start()
			can_take_damage = false
			if health <= 0:
				self.queue_free()

func _on_damage_cooldown_timer_timeout() -> void:
	can_take_damage = true
	
func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= 100:
		health = 100
		healthbar.visible = false
	else:
		healthbar.visible = true
