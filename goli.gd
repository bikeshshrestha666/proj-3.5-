extends RigidBody2D

var projectile_speed = 500
var life_time = 4

func _ready():
	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	Self_Destruct()
	
func Self_Destruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_goli_body_entered(body):
	self.hide()
