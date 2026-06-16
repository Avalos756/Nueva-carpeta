extends CharacterBody2D

# --- VALORES DE FÍSICA ---
@export var speed: float = 1200.0              
@export var jump_velocity: float = -3350.0   
@export var gravity_scale: float = 7.5       

# --- CONFIGURACIÓN DE SALTO ---
@export var min_jump_velocity: float = -1200.0 
@export var fall_gravity_multiplier: float = 3.5 

# --- CONFIGURACIÓN DE PARED (SINTONÍA HORNET) ---
@export var wall_slide_slow_speed: float = 100.0  
@export var wall_slide_fast_speed: float = 350.0  
@export var wall_jump_push: float = 1300.0      
@export var wall_jump_up: float = -3600.0        
@export var wall_jump_lock_time: float = 0.18   

# --- MODO SUPER Y MEJORAS DE DASH ---
@export var dash_speed: float = 3200.0       
@export var sprint_speed: float = 2400.0     
@export var dash_duration: float = 0.15      
@export var dash_cooldown: float = 0.6  
@export var wall_dash_post_lock: float = 0.12  

# --- TUNEO Y BALANCE DEL ATAQUE DASH ---
@export var dash_attack_impulse: float = 5600.0 
@export var dash_attack_decay: float = 140.0   
@export var dash_attack_cooldown: float = 1.0   

# --- VARIABLES DE ESTADO ---
var coyote_timer: float = 0.0
var jump_buffer: float = 0.0
var wall_jump_lock: float = 0.0
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0 
var dash_attack_cooldown_timer: float = 0.0 
var attack_impulse: float = 0.0

var attack_freeze_timer: float = 0.0
var pending_attack_impulse: float = 0.0 

var sprint_grace_timer: float = 0.0
var SPRINT_GRACE_TIME: float = 0.12 

var is_jumping: bool = false 
var is_dashing: bool = false
var is_sprinting: bool = false 
var is_attacking: bool = false
var is_special_attack: bool = false 
var can_dash_in_air: bool = true  

# --- REFERENCIAS ---
@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var dash_sound = $DashSound
@onready var attack_sound = $AttackSound

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if attack_freeze_timer > 0:
		attack_freeze_timer -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		if attack_freeze_timer <= 0:
			attack_impulse = pending_attack_impulse
			velocity.y = 0
		return 

	var input_dir: float = Input.get_axis("izquierda", "derecha") 
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

	# Timers
	coyote_timer -= delta
	jump_buffer -= delta
	wall_jump_lock -= delta
	
	if dash_timer > 0:
		dash_timer -= delta
		if dash_timer <= 0: 
			is_dashing = false
			if is_on_floor() and input_dir != 0:
				is_sprinting = true
			
	if dash_cooldown_timer > 0: dash_cooldown_timer -= delta
	if dash_attack_cooldown_timer > 0: dash_attack_cooldown_timer -= delta 

	if is_on_floor():
		coyote_timer = 0.15
		can_dash_in_air = true 
		is_jumping = false 

	# COMPUERTA DE ADHERENCIA CON TIEMPO DE GRACIA
	if input_dir == 0:
		if is_sprinting:
			sprint_grace_timer -= delta
			if sprint_grace_timer <= 0:
				is_sprinting = false
	else:
		sprint_grace_timer = SPRINT_GRACE_TIME

	# [NUEVA SOLUCIÓN] Si sueltas el botón de dash, dejas de correr inmediatamente
	if not Input.is_action_pressed("dash"):
		is_sprinting = false

	var touching_real_wall = is_on_wall() and not is_on_floor()

	# Ataque
	if Input.is_action_just_pressed("atacar") and not is_attacking:
		var was_running_or_dashing = is_sprinting or is_dashing
		is_sprinting = false        
		
		if touching_real_wall:
			var wall_normal = get_wall_normal()
			sprite.flip_h = wall_normal.x < 0
		
		if was_running_or_dashing and dash_attack_cooldown_timer <= 0:
			is_attacking = true
			if attack_sound: attack_sound.play()
			sprite.frame = 0
			sprite.play("atack_run" if sprite.sprite_frames.has_animation("atack_run") else "atack")
			
			attack_freeze_timer = 0.08
			pending_attack_impulse = dash_attack_impulse 
			is_dashing = false
			is_special_attack = true 
			dash_attack_cooldown_timer = dash_attack_cooldown 
		else:
			is_attacking = true
			if attack_sound: attack_sound.play()
			sprite.frame = 0
			sprite.play("atack")
			attack_impulse = 0 
			is_special_attack = false 

	# Dash
	if Input.is_action_just_pressed("dash") and dash_timer <= 0 and dash_cooldown_timer <= 0:
		if is_on_floor() or can_dash_in_air or touching_real_wall:
			if not is_special_attack: 
				is_dashing = true
				is_sprinting = false 
				dash_timer = dash_duration
				dash_cooldown_timer = dash_cooldown
				velocity.y = 0
				
				if touching_real_wall:
					var wall_normal = get_wall_normal()
					velocity.x = wall_normal.x * dash_speed
					sprite.flip_h = wall_normal.x < 0
					wall_jump_lock = dash_duration + wall_dash_post_lock 
					can_dash_in_air = true 
				else:
					if not is_on_floor(): can_dash_in_air = false 
				
				if dash_sound: dash_sound.play()

	# Salto y Wall Jump
	if Input.is_action_just_pressed("saltar") and not is_special_attack:
		jump_buffer = 0.12
		
	if jump_buffer > 0 and not is_dashing and not is_special_attack:
		if coyote_timer > 0:
			if jump_sound: jump_sound.play()
			velocity.y = jump_velocity
			jump_buffer = 0
			is_jumping = true 
		elif touching_real_wall:
			if jump_sound: jump_sound.play()
			var wall_normal = get_wall_normal()
			velocity.y = wall_jump_up
			velocity.x = wall_normal.x * wall_jump_push
			wall_jump_lock = wall_jump_lock_time 
			jump_buffer = 0
			sprite.flip_h = wall_normal.x < 0
			can_dash_in_air = true 
			is_sprinting = false 
			is_jumping = true

	# Gravedad dinámica y Wall Slide
	if not is_on_floor() and not is_dashing:
		if is_special_attack and attack_impulse > 0:
			velocity.y = 0 
		elif touching_real_wall and velocity.y > 0 and is_jumping:
			var wall_normal = get_wall_normal()
			
			var pressing_into_wall = (input_dir * wall_normal.x) < 0 
			
			if pressing_into_wall:
				velocity.y = wall_slide_slow_speed  
			else:
				velocity.y = wall_slide_fast_speed  
				
			can_dash_in_air = true
			is_sprinting = false 
		else:
			var final_gravity = gravity * gravity_scale
			if is_jumping and velocity.y < 0 and not Input.is_action_pressed("saltar"):
				if velocity.y < min_jump_velocity:
					velocity.y = min_jump_velocity
				final_gravity *= fall_gravity_multiplier
			velocity.y += final_gravity * delta

	# Movimiento horizontal
	if is_dashing:
		if wall_jump_lock <= 0:
			velocity.x = (-dash_speed if sprite.flip_h else dash_speed)
	elif is_special_attack:
		if attack_impulse > 0:
			velocity.x = (-attack_impulse if sprite.flip_h else attack_impulse)
			attack_impulse = move_toward(attack_impulse, 0, dash_attack_decay) 
		else:
			velocity.x = 0 
	elif wall_jump_lock <= 0:
		if input_dir != 0:
			var target_speed = sprint_speed if is_sprinting else speed
			velocity.x = input_dir * target_speed
			sprite.flip_h = input_dir < 0
		else:
			velocity.x = 0

	# EJECUCIÓN DEL MOTOR FÍSICO
	move_and_slide()
	
	# Rompe el sprint si chocas contra la pared corriendo
	if is_sprinting and is_on_wall() and is_on_floor():
		is_sprinting = false

	actualizar_animaciones(input_dir)

func _on_animation_finished():
	if sprite.animation in ["atack", "atack_run"]: 
		is_attacking = false
		is_special_attack = false
		attack_impulse = 0

func actualizar_animaciones(direction: float) -> void:
	if is_attacking:
		return 
		
	if is_dashing:
		sprite.play("dash")
		return
		
	# --- ANIMACIONES EN EL AIRE ---
	if not is_on_floor():
		if is_on_wall_only() and velocity.y > 0 and is_jumping: 
			sprite.play("wall_slide")
		elif velocity.y < 0: 
			# [AQUÍ ESTÁ LO QUE PEDÍAS] Sprites diferentes al saltar corriendo
			if is_sprinting and sprite.sprite_frames.has_animation("run_jump"):
				sprite.play("run_jump")
			else:
				sprite.play("jump")
		else: 
			# [AQUÍ ESTÁ LO QUE PEDÍAS] Sprites diferentes al caer corriendo
			if is_sprinting and sprite.sprite_frames.has_animation("run_fall"):
				sprite.play("run_fall")
			else: 
				sprite.play("fall" if sprite.sprite_frames.has_animation("fall") else "jump")
		return

	# --- ANIMACIONES EN EL SUELO ---
	if direction != 0:
		if is_sprinting:
			sprite.play("run")
		else:
			sprite.play("walk")
	else:
		sprite.play("idle")
