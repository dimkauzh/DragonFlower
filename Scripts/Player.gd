extends KinematicBody2D
var vel = Vector2.ZERO
var health = 300
var speed = 300
var ladder_speed = 150
var jump_speed = -600
var gravity = 1200
var jumping := false
onready var ray_r = $RayCast2D
onready var knife = $Icon
onready var knife_anim = $AnimationPlayer
onready var timer = $Timer
var knife_right = false
var knife_left = false
var jump_count = 0
export var extrajumps = 1

func get_input():
	vel.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed("ui_up")
	
	if jump and jump_count < extrajumps:
		vel.y = jump_speed
		jump_count += 1
		
	if is_on_floor():
		jump_count = 0
		
	if right:
		vel.x += speed
		knife_right = true
		knife_left = false
	elif left:
		vel.x -= speed
		knife_right = false
		knife_left = true
	else:
		vel.x = 0

		
func _process(delta):
	vel = move_and_slide(vel, Vector2.UP)
	vel.y += gravity * delta
	get_input()
	if Input.is_action_just_pressed("attack"):
		if knife_left:
			knife.position.x = -32
			ray_r.cast_to.x = -90
			knife.visible = true
			knife_anim.play("attack_r")
		if knife_right:
			knife.position.x = 32
			ray_r.cast_to.x = 90
			knife.visible = true
			knife_anim.play("attack_r")
		timer.start()
		if ray_r.is_colliding():
			print("got you")
			var ray_r_col = ray_r.get_collider()
			ray_r_col.health -= 50


func _on_Timer_timeout():
	knife.visible = false
