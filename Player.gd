extends KinematicBody2D

var max_speed = 300
var speed = 0
var acceleration = 500
var move_direction = Vector2(0,0)
var anim_direction = "S"
var anim_mode = "Idle"
var animation

var wep = preload("res://goli.tscn")
var can_fire = true
var rate_of_fire = 0.4
var shooting = false

func _physics_process(delta):
	MovementLoop(delta)
	
	
	
func _process(delta):
	AnimationLoop()
	SkillLoop()
	

func SkillLoop():
	if Input.is_action_pressed("Shoot") and can_fire == true:
		can_fire = false
		shooting = true
		speed = 0
		get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
		var wep_instance = wep.instance()
		wep_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
		wep_instance.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(wep_instance)
		yield(get_tree().create_timer(rate_of_fire),"timeout")
		can_fire = true
		shooting = false
		speed = 250
	
func MovementLoop(delta):
	move_direction.x = int(Input.is_action_pressed("Right"))-int(Input.is_action_pressed("Left"))
	move_direction.y = (int(Input.is_action_pressed("Down"))-int(Input.is_action_pressed("Up"))) / float(2)
	if move_direction == Vector2(0,0):
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed :
			speed = max_speed
		var motion = move_direction.normalized() * speed
		move_and_slide(motion)
	
func AnimationLoop():
	
	if shooting == true:
		anim_mode = "Idle"
	else:
		
		match move_direction:
			Vector2(-1,0):
				anim_direction = "W"
			Vector2(1,0):
				anim_direction = "E"
			Vector2(0,0.5):
				anim_direction = "S"
			Vector2(0,-0.5):
				anim_direction = "N"
			Vector2(-1,-0.5):
				anim_direction = "NW"
			Vector2(-1,0.5):
				anim_direction = "SW"
			Vector2(1,-0.5):
				anim_direction = "NE"
			Vector2(1,0.5):
				anim_direction = "SE"
		
		if move_direction != Vector2(0,0):
			anim_mode = "WALK"
		else:
			anim_mode = "IDLE"
		animation = anim_mode + "_" + anim_direction
		get_node("AnimationPlayer").play(animation)
	


