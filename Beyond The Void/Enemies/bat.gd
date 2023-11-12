extends CharacterBody2D

var speed = 35
var player = null
var chase = false

var knockback = Vector2.ZERO
var knockback_strength = 2.0

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()
	print("Hello")
	if chase:
		position += (player.position - position)/speed

func _on_detection_area_body_entered(body):
	print(body)
	player = body
	chase = true

func _on_detection_area_body_exited(body):
	player = null
	chase = false

func _on_hurt_box_area_entered(area):
	if area.get_parent().get_parent().name == "Player":
		var pl = area.get_parent().get_parent()
		var direction = global_position.direction_to(pl.global_position) * -1
		velocity += direction * 115
