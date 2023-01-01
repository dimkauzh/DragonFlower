extends KinematicBody2D

var health = 100
var gravity = 100
var vel = Vector2.ZERO
var speed = 150
var normal_speed = 150
var player = null
var player_attacker
onready var player_node = get_node("/root/World/Player")
onready var timer = $Timer
export var direction_autowalk = 1


func _physics_process(_delta):
	if health <= 0:
		queue_free()
	if player:
		var direction = (player.position - position).normalized()
		if not is_on_floor():
			direction.y += gravity
		move_and_slide(direction * speed)
	if player == null:
		if is_on_wall():
			direction_autowalk = direction_autowalk * -1
		print(direction_autowalk)
		vel.y += 2
		vel.x = direction_autowalk * speed
		move_and_slide(vel, Vector2.UP)

func _on_Player_Checker_body_entered(body):
	player = body
		
func _on_Player_Checker_body_exited(_body):
	player = null

func _on_Player_attacker_body_entered(body):
	player_attacker = body
	if body.is_in_group("player"):
		body.health -= 10
		timer.start()

func _on_Player_attacker_body_exited(body):
	player_attacker = null

func _on_Timer_timeout():
	if player_attacker and player_attacker.is_in_group("player"):
		player_node.health -= 10
		timer.start()

