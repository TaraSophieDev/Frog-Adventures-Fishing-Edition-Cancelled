extends KinematicBody2D

onready var sprite = $Sprite
onready var ap = $AnimationPlayer
onready var rc = $RC

enum {
	IDLE,
	NEW_DIR,
	MOVE,
	BAITED
}

func _ready():
	randomize()

var SPEED = 10
var state = IDLE
var dir = Vector2.RIGHT

func _process(delta):
	if rc.is_colliding():
		state = baited()
	match state:
		IDLE:
			ap.stop()
		NEW_DIR:
			dir = choose([Vector2.RIGHT, Vector2.LEFT])
			state = choose([IDLE, MOVE])
		MOVE:
			move(delta)
		BAITED:
			baited()

func move(delta):
	# Rotates raycast
	var temp = rad2deg(atan2(-dir.y, -dir.x))
	rc.rotation_degrees = temp

	ap.play("Swim")
	position += dir * SPEED * delta
	print(dir.x)
	if dir.x == 1:
		sprite.flip_h = true
	elif dir.x == -1:
		sprite.flip_h = false

func choose(array):
	array.shuffle()
	return array.front()

func baited():
	print("baited")

func _on_Timer_timeout():
	$Timer.wait_time = choose([1, 1.5, 2])
	print($Timer.wait_time)
	state = choose([IDLE, NEW_DIR, MOVE])
