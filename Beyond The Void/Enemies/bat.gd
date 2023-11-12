extends CharacterBody2D

@export var SPEED = 40
@export var ACC = 300
@export var FRICTION = 200

@onready var init_pos = position

var player = null
var rotation_angle = rotation
var health = GlobalVar.Bat_health

enum {IDLE,WANDER,CHASE}

var state = IDLE
var knockback = Vector2.ZERO
var knockback_strength = 2.0

var Dead_anim = preload("res://Effects/enemy_death_effect.tscn")


func _physics_process(delta):
#	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#	move_and_slide()
	
	match state:
		IDLE :
			var dir = (init_pos - global_position ).normalized()
			velocity = velocity.move_toward(dir * SPEED, ACC * delta)
			move_and_slide()
			rotation = rotation_angle

#			$Bat_Sprite.flip_h = velocity.x > 0
#			velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#			move_and_slide()
		CHASE: 
#			position += (player.position - position)/SPEED
			rotation = position.angle_to_point(player.global_position) - deg_to_rad(90)
			var dir = (player.global_position - global_position ).normalized()
			velocity = velocity.move_toward(dir * SPEED, ACC * delta)
			move_and_slide()
			
#			$Bat_Sprite.flip_h = velocity.x < 0
		WANDER:
			pass

func _on_detection_area_body_entered(body):
	if body.name=="Player":
		state = CHASE
		player = body

func _on_detection_area_body_exited(body):
	if body.name=="Player":
		state = IDLE
		player = null

func _on_hurt_box_area_entered(area):
	if area.get_parent().get_parent().name == "Player":
		var pl = area.get_parent().get_parent()
		var direction = global_position.direction_to(pl.global_position) * -1
		velocity += direction * 115
		health -= GlobalVar.Hit_Damage
		
		if health == 0:
			var dead_obj = Dead_anim.instantiate()
			get_parent().add_child(dead_obj)
			dead_obj.global_position = global_position
			dead_obj.play("Animate")
			queue_free()
			
