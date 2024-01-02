extends KinematicBody2D
onready var jiban = get_node("Jiban")

var max_hp = 400
var current_hp
var percentage_hp

func _ready():
	get_node("AnimationPlayer").play("Idle_SW")
	current_hp = max_hp

func OnHit(damage):
	current_hp -= damage
	jiban_update()
	if current_hp <= 0:
		OnDeath()
		
		
func jiban_update():
	percentage_hp = int((float(current_hp) / max_hp) * 100)
	get_node("Jiban/Tween").interpolate_property(jiban, 'value', jiban.value, percentage_hp, 0.1 , Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Jiban/Tween").start()
	if percentage_hp >= 60:
		jiban.set_tint_progress("14e114") #green
	elif percentage_hp <= 60 and percentage_hp >=25:
		jiban.set_tint_progress("e1be32") #orange
	else:
		jiban.set_tint_progress("e11e1e") #red

func OnDeath():
	get_node("CollisionShape2D").set_deferred("disabled", true)
	get_node("AnimationPlayer").play("Die_SW")
	jiban.hide()
