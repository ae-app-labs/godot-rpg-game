extends CharacterBody2D

const speed = 100
var current_direction = "none"
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_in_progress = false

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("Player died")
		self.queue_free() 
		# end screen

func player_movement(_delta: float):
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_anim(movement):
	var dir = current_direction
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("front__idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_in_progress == false:
				anim.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		#print("== enemy entered player hitbox")
		enemy_in_attack_range = true
	
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		#print("== enemy exited player hitbox")
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health -= 10
		print("player health:", health)
		enemy_attack_cooldown = false
		$AttackCooldownTimer.start()
	
func _on_attack_cooldown_timer_timeout() -> void:
	$AttackCooldownTimer.stop()
	#print("timer timeout")
	enemy_attack_cooldown = true

func attack():
	var dir = current_direction
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_in_progress = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$DealAttackTimer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$DealAttackTimer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$DealAttackTimer.start()	
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$DealAttackTimer.start()

func _on_deal_attack_timer_timeout() -> void:
	$DealAttackTimer.stop()
	global.player_current_attack = false
	attack_in_progress = false
	
func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	elif global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true
		
func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= 100:
		health = 100
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout() -> void:
	if health < 100:
		health += 20
